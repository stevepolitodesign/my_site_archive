class ZoneFilesController < ApplicationController
    before_action :set_website, only: [:index, :show]
    before_action :set_zone_file, only: [:show]

    def index
        authorize @website, :show?
        @pagy, @zone_files = pagy(@website.zone_files.order(created_at: :desc))
    end

    private

        def set_website
            @website = Website.find(params[:website_id])
        end

        def set_zone_file
            @zone_file = ZoneFile.find(params[:id])
        end        
end
