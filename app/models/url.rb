class Url < ApplicationRecord
    attr_accessor :request_uri

    def link
        request_uri + self.short_url
    end

end