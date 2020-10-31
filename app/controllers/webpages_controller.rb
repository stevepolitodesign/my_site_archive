class WebpagesController < ApplicationController
    before_action :set_webpage, only: [:show]
    before_action :set_website, only: [:create]

    def show
    end

    def create
        @webpage = @website.webpages.create(webpage_params)
        if @webpage.save
            redirect_to website_webpage_path(@website, @webpage), notice: "Webpage saved."
            CreateHtmlDocumentJob.perform_now(@webpage.id)
        else
            redirect_to @website, notice: "There was an error saving this webpage."
        end
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
