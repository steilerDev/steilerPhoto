require 'exif'
require 'image_optimizer'
require 'fileutils'

# This class defines helper methods
class PictureGenerator

    # This function takes a post (from the hook calls) and calls the block with each picture's full path associated to the given post
    # block: Closure that takes four arguments: 
    #   - source: The full path to the source file ('/some/source/image.jpg')
    #   - cache_base: The cache base name ('/some/cache/image')
    #   - base_filename: The file base name ('image')
    #   - picture_title: The sanitized picture title ("An awesome title")
    def self.iterate_associated_pictures(post, &block)

        picture_ext = post.site.config["picture_generator"]["extension"]

        # Get path, where pictures for this post are expected
        picture_src_dir = File.join(post.site.source, post.site.config["picture_generator"]["source"], post.basename)
        picture_src_dir.slice!(post.extname)

        # Find and - if necessary - create cache dir
        picture_cache_dir = File.join(post.site.source, post.site.config["picture_generator"]["cache"], post.basename)
        picture_cache_dir.slice!(post.extname)
        if ! File.directory?(picture_cache_dir)
            Jekyll.logger.warn "Creating cache dir " << picture_cache_dir
            FileUtils::mkdir_p picture_cache_dir
        else
            Jekyll.logger.debug "Cache dir exists " << picture_cache_dir
        end

        # Check if path exists
        if File.directory?(picture_src_dir)
            Jekyll.logger.debug "Found picture directory related to post: " << picture_src_dir

            # Iterate over all pictures in the directory and making sure they are in the correct order
            pictures = Dir.glob(File.join(picture_src_dir, '*' << picture_ext)).sort!
            pictures.each do |source|

                # The filename without extension
                base_filename = File.basename(source, picture_ext)
                
                # The cache path is the base cache dir plus the basename of the picture without extension
                cache_base = File.join(picture_cache_dir, base_filename)

                # The title is the filename without the leading three characters (XX-) and whitespace instead of underscores
                picture_title =  base_filename[3..-1].gsub('_', ' ')

                yield source, cache_base, base_filename, picture_title
            end
        else
            Jekyll.logger.warn "No picture directory related to post \"" << post.basename << "\" found!"
        end
    end

    # Keeping track of chached files for log purposes
    @@skipped_files = 0
    def self.number_of_skipped_files
        @@skipped_files
    end
    def self.reset_muber_of_skipped_files
        @@skipped_files = 0
    end

    # This function handles caching of images, if a new image is created, it will be automatically optimized
    # - source: The full path ('/some/path/image.jpg')
    # - cache_base: The cache base name ('/some/cache/image')
    # - dest_base: The destination base name ('/some/dest/image')
    # - ext: The extension ('_full.jpg')
    # - block: Closure that takes two arguments: full path for source and destination
    def self.cache_image(source, cache_base, dest_base, ext, &block)
        # Cache image
        image_cache = cache_base.dup << ext
        # Final destination image
        image_dest = dest_base.dup << ext

        if ! File.file?(image_dest)
            Jekyll.logger.debug "Creating " << image_dest
            if ! File.file?(image_cache)
                Jekyll.logger.debug "Creating " << image_cache
                yield source, image_cache
                PictureGenerator.optimize_image(image_cache)
            else
                @@skipped_files += 1
                Jekyll.logger.debug "Not creating " << image_cache << " because it already exists"
            end
            Jekyll.logger.debug "Copying " << image_cache << " to " << image_dest
            FileUtils::copy(image_cache, image_dest) 
            File.chmod(0644, image_dest)
        else
            Jekyll.logger.warn "Skipping " << ext << " for " << source << " because " << image_dest << " already exists"
        end
    end

    # Optimizes the given image in-place using ImageOptimizer
    def self.optimize_image(image)
        Jekyll.logger.debug "Optimizing " << image
        ImageOptimizer.new(image, quiet: true).optimize
    end
    
    # Converts source to destination using options from block
    # - src: The full path to the source image
    # - dest: The full path to the destination
    # - block: A closure giving MiniMagick combine_options
    def self.convert_image(src, dest, &block)
        Jekyll.logger.debug "Creating " << dest
        image = MiniMagick::Image.open(src)
        image.combine_options do |b|
            yield b
        end
        image.format "PJPEG"
        image.write(dest)
        Jekyll.logger.debug "Wrote " << dest
    end
end

# This hook will be called for each post, before it gets rendered. The hook inserts the picture URL and descriptions into the font manner of the post.
Jekyll::Hooks.register :posts, :pre_render do |post|
    Jekyll.logger.debug "Now populating post \"" << post.basename << "\""

    PictureGenerator.iterate_associated_pictures(post) { |source, _, base_filename, picture_title|
        # Create array in font manner, if not yet defined
        if ! post.data.key?("pictures")
            post.data["pictures"] = Array.new
        end
       
        # Adding first picture as reference for atom feed 
        if ! post.data.key?("image")
            post.data["image"] = File.join(post.site.data["global"]["url"], source)
        end

        picture = {"filename"=>base_filename}

        # Get all necessary information required in the post from exif
        data = Exif::Data.new(source)
        picture["title"] = picture_title
        if data.model
            if data.model.start_with?('SLT')
                picture["camera"] = "Sony " << data.model
            else
                picture["camera"] = data.model
            end
        end
        picture["iso"] = data.iso_speed_ratings
        picture["focal-length"] = data.focal_length
        picture["aperture"] = data.fnumber
        picture["exposure"] = data.exposure_time

        Jekyll.logger.debug "Read file \"" << source << "\": "
        Jekyll.logger.debug picture
        post.data["pictures"] << picture
    }
end

# This hook will be called for each post, after it got written to disk. The hook will convert the pictures and write them to their destination.
Jekyll::Hooks.register :posts, :post_write do |post|
    destination = File.join(post.site.dest, post.url)

    Jekyll.logger.warn "Creating pictures for \"" << post.url << "\", this might take a while..."
    PictureGenerator.iterate_associated_pictures(post) { |source, cache_base, base_filename, _|

        Jekyll.logger.debug "Creating pictures for \"" << source << "\", this might take a while..."

        # The base path for the destination files ('/some/dest/image')
        dest_base = File.join(destination, base_filename)

        # Create preview only for first picture
        preview_dest = File.join(destination, "preview.jpg")
        if ! File.file?(preview_dest)
            preview_cache = File.join(File.dirname(cache_base), "preview.jpg")
            PictureGenerator.cache_image(source, preview_cache, preview_dest, "") { |src, dst|
                Jekyll.logger.debug "Creating preview"
                %x[convert -page +20+20 #{src} -quality 70 -resize '450' -alpha set \\( +clone -background black -shadow 60x10+20+20 \\) +swap -background white -strip -mosaic -sampling-factor 4:2:0 -colorspace RGB PJPEG:#{dst}]
            }
        end
        
        # Default image
        PictureGenerator.cache_image(source, cache_base, dest_base, ".jpg") { |src, dst|
            PictureGenerator.convert_image(src, dst) { |b|
                b.quality "80"
                b.resize "1024"
                b.colorspace "RGB"
                b.sampling_factor "4:2:0"
            }
        }

        # Full image
        PictureGenerator.cache_image(source, cache_base, dest_base, "_full.jpg") { |src, dst|
            PictureGenerator.convert_image(src, dst) { |b|
                b.quality "80"
            }
        }

        # Thumbnail image
        PictureGenerator.cache_image(source, cache_base, dest_base, "_thumb.jpg") { |src, dst|
            PictureGenerator.convert_image(src, dst) { |b|
                b.quality "50"
                b.resize "128"
                b.colorspace "RGB"
                b.sampling_factor "4:2:0"
            }
        }
    }
    if PictureGenerator.number_of_skipped_files > 0 
        Jekyll.logger.warn "Not creating #{PictureGenerator.number_of_skipped_files} pictures, because they were read from cache"
        PictureGenerator.reset_muber_of_skipped_files
    end 
end

