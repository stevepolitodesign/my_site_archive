class WebsitesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_website, only: [:show, :edit, :update, :destroy]

    def index
        @websites = current_user.websites
    end

    def show
        authorize @website
        @webpage = @website.webpages.build
    end

    def new
        @website = current_user.websites.build
        authorize @website
    end

    def edit
        authorize @website
    end

    def create
        @website = current_user.websites.create(website_params)
        authorize @website
        if @website.save
            redirect_to @website, notice: "Website created."
            # TODO: Consider running @website.capture_new_zone_file
            CreateZoneFileJob.perform_later(@website.id)
        else
            render "new"
        end
    end

    def update
        authorize @website
    end

    def destroy
        authorize @website
    end

    private

        def website_params
            params.require(:website).permit(:title, :url)
        end

        def set_website
            @website = Website.find(params[:id])
        end
end
