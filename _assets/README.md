This folder contains all asset files. They will be copied to `/assets/` in the webroot. Every CSS and JS will be minified and all files will receive their hash value as part of the file name. This enables aggresive caching of asset ressoruces.

Reference assets always using `{% asset_path <filename> %}`
