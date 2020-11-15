class WebpagesController < ApplicationController
    # TODO: Authenticate subscription
    before_action :authenticate_user!
    before_action :set_webpage, only: [:show, :edit, :update, :destroy]
    before_action :set_website, only: [:create]

    def show
        authorize @webpage
    end

    def edit
        authorize @webpage
    end

    def create
        @webpage = @website.webpages.create(webpage_params)
        if @webpage.save
            redirect_to website_webpage_path(@website, @webpage), notice: "Webpage saved."
            CreateHtmlDocumentJob.perform_later(@webpage.id)
            CreateScreenshotJob.perform_later(@webpage.id)
        else
            redirect_to @website, alert: @webpage.errors.full_messages.to_sentence
        end
    end

    def update
        authorize @webpage
    end

    def destroy
        authorize @webpage
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
