class WebpagesController < ApplicationController
    before_action :set_webpage, only: [:show, :edit, :update, :destroy]
    before_action :set_website, only: [:create]

    def show
        authorize @webpage
    end

    def edit
        authorize @webpage
    end

    def create
        authorize @webpage
        @webpage = @website.webpages.create(webpage_params)
        if @webpage.save
            redirect_to website_webpage_path(@website, @webpage), notice: "Webpage saved."
            # TODO: Condider running @webpage.capture_new_html_document
            CreateHtmlDocumentJob.perform_later(@webpage.id)
            # TODO: Condider running @webpage.capture_new_screenshot
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
