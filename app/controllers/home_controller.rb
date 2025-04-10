class HomeController < ApplicationController
    def index 
        puts "HomeController index action called"
        render text: "hello world"
        #render "home/index", layout: false 
    end
end
