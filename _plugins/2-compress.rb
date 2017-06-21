# This hook does static compression for configured files, using brotli and/or gzip. Additionally it is modifying the .htaccess file, in order to properly server the files.
# Settings in _conf.yml:
# compress_files:
#   compressions: [List of supported compressions, that should be used, currently supported: 'gzip' and 'brotli']
#   file_types: [List of file types that should be compressed]
# To disable set compress_files: false

require 'mime/types'

Jekyll::Hooks.register :site, :post_write do |site|
    if site.config["compress_files"]  
        Jekyll.logger.info "Compressing files..."
        open("#{site.dest}/.htaccess", 'a') do |htaccess|

            htaccess.puts "#"
            htaccess.puts "# Auto-generated in order to support static compression through Jekyll plugin by steilerDev"
            htaccess.puts "#"
            htaccess.puts "FileETag None"

            site.config["compress_files"]["file_types"].each do |f_type|
                mime = MIME::Types.type_for(f_type)
                if mime.empty?
                    Jekyll.logger.warn "Cannot find associated MIME type for #{f_type}, not compressing"
                else
                    Jekyll.logger.info "Compressing file type #{f_type}..."

                    # Writing encoding directions to htaccess
                    if site.config["compress_files"]["compressions"].include? ('gzip')
                        htaccess.puts "<Files *.#{f_type}.gz>"
                        htaccess.puts "  AddType #{mime.first} .gz"
                        htaccess.puts "  AddEncoding gzip .gz"
                        htaccess.puts "</Files>"
                    end
                    if site.config["compress_files"]["compressions"].include? ('brotli')
                        htaccess.puts "<Files *.#{f_type}.br>"
                        htaccess.puts "  AddType #{mime.first} .br"
                        htaccess.puts "  AddEncoding br .br"
                        htaccess.puts "</Files>"
                    end

                    # Compressing files
                    Dir.glob("#{site.dest}/**/*.#{f_type}") do |file|
                        if site.config["compress_files"]["compressions"].include? ('gzip')
                            Jekyll.logger.debug "Compressing #{file} using gzip"
                            %x[gzip -f -k --best #{file}]
                        end
                        if site.config["compress_files"]["compressions"].include? ('brotli')
                            Jekyll.logger.debug "Compressing #{file} using brotli"
                            %x[brotli -f -k --best #{file}]
                        end
                    end
                end
            end

            # Writing to rewrite rules to htaccess
            htaccess.puts "RewriteEngine On"
            if site.config["compress_files"]["compressions"].include? ('brotli')
                htaccess.puts "RewriteCond %{HTTP:Accept-Encoding} br"
                htaccess.puts "RewriteCond %{REQUEST_FILENAME}.br -f"
                htaccess.puts "RewriteRule ^(.*)$ $1.br [L]"
            end
            if site.config["compress_files"]["compressions"].include? ('gzip')
                htaccess.puts "RewriteCond %{HTTP:Accept-Encoding} gzip"
                htaccess.puts "RewriteCond %{REQUEST_FILENAME}.gz -f"
                htaccess.puts "RewriteRule ^(.*)$ $1.gz [L]"
            end
        end
    end
end
