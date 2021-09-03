class ApplicationController < ActionController::Base
    protect_from_forgery with: :null_session
    helper_method :build_url

    def build_url(path)
        "#{request.base_url}/#{path}"
    end
end
