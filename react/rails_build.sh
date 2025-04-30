#!/bin/bash

npm run build
cp dist/assets/index-*.js ../app/assets/javascripts/bundle.js 
cp dist/assets/index-*.css ../app/assets/stylesheets/bundle.css 
