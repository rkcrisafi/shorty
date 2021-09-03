class UrlsController < ApplicationController

    def show
        short_url = build_url(params[:path])
        @url = Url.find_by(short_url: short_url)
        if @url.present?
            @url_visit = ShortUrlVisit.create(short_url: build_url(params[:path]))
            redirect_to @url.long_url
        else
            render json: { message: 'Not found' }, status: 404
        end
    end
    
    def create
        if url_params[:custom_back_half].present?
            short_url = build_url(url_params[:custom_back_half])
            url = Url.find_by(short_url: short_url)
            if  url.present?
                render json: { message: "This URL has already been claimed for #{url.long_url}" }, status: 409
                return
            end
        else
            @url = url = Url.find_by(long_url: url_params[:long_url])
            if @url.present?
                render :show
                return
            else
                short_url = build_url(SecureRandom.alphanumeric(7))
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