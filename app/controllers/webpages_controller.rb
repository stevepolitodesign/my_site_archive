class WebpagesController < ApplicationController
    before_action :set_webpage, only: [:show, :edit, :update, :destroy]
    before_action :set_website, only: [:create, :edit, :update]

    def show
        authorize @webpage
        @html_documents = @webpage.html_documents
        @screenshots    = @webpage.screenshots
    end

    def edit
        authorize @webpage
    end

    def create
        authorize @website
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
        if @webpage.update(webpage_params)
            redirect_to website_webpage_path(@website, @webpage), notice: "Webpage updated."
        else
            render :edit
        end
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
