class UrlsController < ApplicationController

    def show
        short_url = build_url(params[:path])
        @url = Url.find_by(short_url: short_url)
        if @url.present?
            @url_visit = ShortUrlVisit.create(short_url: build_url(params[:path]))
            redirect_to @url.long_url
        else
            # in case a short url does not exist
            render json: { message: 'Not found' }, status: 404
        end
    end
    
    def create
        # for a custom back-half
        if url_params[:custom_back_half].present?
            short_url = build_url(url_params[:custom_back_half])
            url = Url.find_by(short_url: short_url)
            # if it is been declared, we won't allow client to create a duplicate
            if  url.present?
                render json: { message: "This URL has already been claimed for #{url.long_url}" }, status: 409
                return
            end
        else
            # for basis short links
            @url = url = Url.find_by(long_url: url_params[:long_url])
            # render exisiting short link if long URL is already in the DB
            if @url.present?
                render :show
                return
            else
                # generate random back-half
                short_url = build_url(SecureRandom.alphanumeric(7))
                # check for an extremely rare case of collision 
                while Url.where(short_url: short_url).present?
                    short_url = build_url(SecureRandom.alphanumeric(7))
                end
            end
        end

        @url = Url.new(long_url: url_params[:long_url], short_url: short_url)

        if @url.save
            render :show
        else 
            render json: { message: @url.errors.full_messages[0] }
        end
    end

    private

    def url_params
        params.require(:url).permit(:long_url, :custom_back_half)
    end

end