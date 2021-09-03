class ShortUrlVisitsController < ApplicationController

    def get_stats
        @url = Url.find_by(short_url: build_url(params[:path].split('/stats/')[0]))
        visited_total = ShortUrlVisit.where(short_url: @url.short_url).count
        visited_today = ShortUrlVisit.where(short_url: @url.short_url, created_at: Time.now.midnight..Time.now.end_of_day).count

        stats = {
            created: @url.created_at,
            visited_today: visited_today,
            visited_total: visited_total
        }
        render json: stats
    end

end
