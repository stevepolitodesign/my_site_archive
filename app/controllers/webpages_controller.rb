class WebpagesController < ApplicationController
    before_action :set_webpage, only: [:show, :edit, :update, :destroy]
    before_action :set_website, only: [:create, :edit, :update]

    def show
        authorize @webpage
        @pagy, @screenshots = pagy(@webpage.screenshots.order(created_at: :desc).with_attached_image.includes([:html_document]))
    end

    def edit
        authorize @webpage
    end

    def create
        authorize @website
        @webpage = @website.webpages.create(webpage_params)
        if @webpage.save
            redirect_to website_webpage_path(@website, @webpage), notice: "Webpage saved."
            @webpage.capture_new_screenshot
        else
            redirect_to @website, alert: @webpage.errors.full_messages.to_sentence
        end
    end

    def update
        authorize @webpage
        if @webpage.update(webpage_params)
            redirect_to website_webpage_path(@website, @webpage), notice: "Webpage updated."
        else
            render :edit
        end
    end

    def destroy
        authorize @webpage
        @webpage.destroy
        redirect_to websites_path, notice: "Webpage deleted."
    end

    private 

        def set_webpage
            @webpage = Webpage.find(params[:id])
        end

        def set_website
            @website = Website.find(params[:website_id])
        end

        def webpage_params
            params.require(:webpage).permit(:title, :url)
        end
end
