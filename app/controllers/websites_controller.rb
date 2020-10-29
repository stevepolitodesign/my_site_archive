class WebsitesController < ApplicationController
    def new
        @website = Website.new
    end

    def create
        @website = Website.create(website_params)
        if @website.save
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

    private

        def website_params
            params.require(:website).permit(:title, :url)
        end
end
