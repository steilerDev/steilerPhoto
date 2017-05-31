require 'exif'
require 'image_optimizer'

# This class defines helper methods
class PictureGenerator
    # This function takes a post (from the hook calls) and calls the block with each picture's full path associated to the given post
    def self.iterate_associated_pictures(post, &block)
        # TODO: Central config?
        picture_ext = '.jpg'

        # Get path, where pictures for this post are expected
        picture_dir = File.join(post.site.source, '_images', post.basename)
        picture_dir.slice!(post.extname)

        # Check if path exists
        if File.directory?(picture_dir)
            Jekyll.logger.debug "Found picture directory related to post: " << picture_dir

            # Iterate over all pictures in the directory
            pictures = File.join(picture_dir, '*' << picture_ext)
            # Making sure they are in the correct order
            picture_list = Dir.glob(pictures).sort!
            picture_list.each do |picture_path|
                picture_filename = File.basename(picture_path, picture_ext)
                picture_title =  picture_filename[3..-1].gsub('_', ' ')
                yield picture_path, picture_filename, picture_title
            end
        else
            Jekyll.logger.warn "No picture directory related to post \"" << post.basename << "\" found!"
        end
    end
    
    # Converts source to destination/filename+extension using options from block
    def self.convert_image(source, destination, filename, extension, &block)
        image_output = File.join(destination, filename)
        image_output << extension
        if ! File.file?(image_output) 
            Jekyll.logger.debug "Creating " << image_output
            image = MiniMagick::Image.open(source) 
            image.combine_options do |b|
                yield b
            end
            image.format "PJPEG"
            image.write(image_output)
            Jekyll.logger.debug "Optimizing " << image_output
            ImageOptimizer.new(image_output, quiet: true).optimize
            Jekyll.logger.debug "Wrote " << image_output
        else
            Jekyll.logger.debug "Skipping " << image_output
        end
    end

end

# This hook will be called for each post, before it gets rendered. The hook inserts the picture URL and descriptions into the font manner of the post.
Jekyll::Hooks.register :posts, :pre_render do |post|
    Jekyll.logger.debug "Now populating post \"" << post.basename << "\""

    PictureGenerator.iterate_associated_pictures(post) { |picture_path, picture_filename, picture_title|
        # Create array in font manner, if not yet defined
        if ! post.data.key?("pictures")
            post.data["pictures"] = Array.new
        end
       
        # Adding first picture as reference for atom feed 
        if ! post.data.key?("image")
            post.data["image"] = File.join(post.site.data["global"]["url"], picture_path)
        end

        picture = {"filename"=>picture_filename}

        # Get all necessary information required in the post from exif
        data = Exif::Data.new(picture_path)
        picture["title"] = picture_title
        if data.model.start_with?('SLT')
            picture["camera"] = "Sony " << data.model
        else
            picture["camera"] = data.model
        end
        picture["iso"] = data.iso_speed_ratings
        picture["focal-length"] = data.focal_length
        picture["aperture"] = data.fnumber
        picture["exposure"] = data.exposure_time

        Jekyll.logger.debug "Read file \"" << picture_path << "\": "
        Jekyll.logger.debug picture
        post.data["pictures"] << picture
    }
end

# This hook will be called for each post, after it got written to disk. The hook will convert the pictures and write them to their destination.
Jekyll::Hooks.register :posts, :post_write do |post|
    destination = File.join(post.site.dest, post.url)

    Jekyll.logger.warn "Creating pictures for \"" << post.url << "\", this might take a while..."
    PictureGenerator.iterate_associated_pictures(post) { |picture_path, picture_filename, picture_title|
        Jekyll.logger.debug "Creating pictures for \"" << picture_path << "\", this might take a while..."

        # Create preview only for first picture
        preview_dest = File.join(destination, "preview.jpg")
        if ! File.file?(preview_dest)
            Jekyll.logger.debug "Creating preview"
            %x[convert -page +20+20 #{picture_path} -quality 70 -resize '800' -alpha set \\( +clone -background black -shadow 60x10+20+20 \\) +swap -background white -mosaic PJPEG:#{preview_dest}]
            ImageOptimizer.new(preview_dest, quiet: true).optimize
        end
        
        # Default image
        PictureGenerator.convert_image(picture_path, destination, picture_filename, ".jpg") { |b|
            b.quality "80"
            b.resize "1024"
        }

        # Full image
        PictureGenerator.convert_image(picture_path, destination, picture_filename, "_full.jpg") { |b|
            b.quality "80"
        }

        # Thumbnail image
        PictureGenerator.convert_image(picture_path, destination, picture_filename, "_thumb.jpg") { |b|
            b.quality "50"
            b.resize "128"
        }
    }
end

