steilerPhoto
============

A photo blog created using the static page generator jekyll, jQuery, Bootstrap and other Javascript libraries.

The page is highly responsive and speed optimized. Receiving top grades within several website tests. 

The photographies (placed in /_pictures/) have been removed from the repository due to space and performance limitations. See the readme in the folder, in order to understand its structure.

### Optimizations:
* Usage of progressive JPEGs
* Automatic compression of JPEGs
* Usage of browser caching for complete page (within apache2)
* No need of server side scripting at all
* Automatic combination of JavaScript and CSS into one compressed file, using YUI compressor
* Caching of fonts, javascript and css for up to one year. Tracking changes within files using MD5 hashes of the current content as part of the file name.

### Responsiveness: 
* Responsive design through Twitter Bootstrap
* Usage of smaller JPEGs on mobile devices using Picturefill
* Responsive adjustments of captions within Fotorama (No caption on very small devices: width < 767px; No title within caption on small devices: width < 991px)
* Responsive adjustments of social media links within navbar

### Requirements for editing and uploading:
* Ruby
* jekyll
* bundle
* For automated picture optimization through jekyll
	* ImageMagick (www.imagemagick.org/)
	* libjpeg (>= 6a)
	* jpegoptim (>= 1.3.0)
    * libexif-dev
* Additional Ruby gems managed through bundle
* NPM and [PurifyCSS](https://github.com/purifycss/purifycss)

### Setup
* `git clone` the repository
* Install necessary dependencies ([see here](https://jekyllrb.com/docs/installation/))
* Run `bundle install` to get all necessary gems
* Run `bundle exec jekyll server` to build the site and start a local web server
