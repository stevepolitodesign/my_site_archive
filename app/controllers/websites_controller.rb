class WebsitesController < ApplicationController
    before_action :set_website, only: [:show, :edit, :update, :destroy]

    def index
        @websites = current_user.websites.with_attached_image
    end

    def show
        authorize @website
        @webpage = @website.webpages.build
        @webpages = @website.webpages.includes([latest_screenshot: [image_attachment: :blob]])
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
            @website.capture_screenshot
            @website.capture_new_zone_file
        else
            render "new"
        end
    end

    def update
        authorize @website
        if @website.update(website_params)
            redirect_to @website, notice: "Website updated."
        else
            render :edit
        end
    end

    def destroy
        authorize @website
        @website.destroy
        redirect_to websites_path, notice: "Website deleted."
    end

    private

        def website_params
            params.require(:website).permit(:title, :url)
        end

        def set_website
            @website = Website.find(params[:id])
        end
end
