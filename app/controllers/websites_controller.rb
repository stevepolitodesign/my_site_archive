class WebsitesController < ApplicationController
    before_action :set_website, only: [:show]

    def new
        @website = Website.new
    end

    def create
        @website = Website.create(website_params)
        if @website.save
            redirect_to @website, notice: "Website created."
            CreateZoneFileJob.perform_later(@website.id)
        else
            render "new"
        end
    end

    def show
        @webpage = @website.webpages.build
    end

    private

        def website_params
            params.require(:website).permit(:title, :url)
        end

        def set_website
            @website = Website.find(params[:id])
        end
end
