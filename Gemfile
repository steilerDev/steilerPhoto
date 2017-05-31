source "https://rubygems.org"
ruby "2.4"

# Hello! This is where you manage which Jekyll version is used to run.
# When you want to use a different version, change it below, save the
# file and run `bundle install`. Run Jekyll with `bundle exec`, like so:
#
#     bundle exec jekyll serve
#
# This will help ensure the proper Jekyll version is running.
# Happy Jekylling!

gem "jekyll", "3.4.3"

# If you have any plugins, put them here!
group :jekyll_plugins do
    gem "jekyll-feed", "~> 0.6"
    gem 'jekyll-sitemap'
    gem 'jekyll-last-modified-at'
    gem "jekyll-assets"
    gem 'octopress-paginate'

    #
    # Additional gems for jekyll-assets
    #

    gem "uglifier"      # And we want our javascripts to be minified with UglifyJS
    gem "sass"          # And we want to write our stylesheets using SCSS/SASS
    gem "therubyracer"  # JS runtime for sass

    #
    # Additional gems for PictureGenerator
    #
    gem "exif"
    gem "mini_magick"
    gem 'image_optimizer'

    gem 'jekyll-deploy'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
# gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
