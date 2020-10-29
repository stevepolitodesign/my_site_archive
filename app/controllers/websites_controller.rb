class WebsitesController < ApplicationController
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

    private

        def website_params
            params.require(:website).permit(:title, :url)
        end
end
