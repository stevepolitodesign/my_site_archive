class WebsitesController < ApplicationController
    before_action :set_website, only: [:show]

    def new
        @website = Website.new
    end

    def create
        @website = Website.create(website_params)
        if @website.save
            # TODO: Make this a job instead
            result = ZoneFileCreator.new(@website).call
            if result.success?
                redirect_to @website, notice: "Website created."
                @zone_file = result.payload
                CreateDnsRecordsJob.perform_later(@zone_file.id)
            else
                @website.destroy
                render "new", notice: result.error  
            end
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
