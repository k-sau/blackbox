class ApplicationController < ActionController::Base

    def hello_world
        render html: "hello, world!"
    end
    
end
