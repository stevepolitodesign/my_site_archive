class ZoneFileCreator
    def initialize(website)
        @website = website
    end

    def call
        @zone_file = @website.zone_files.create
        if @zone_file.save
            OpenStruct.new({success?: true, payload: @zone_file})
        else
            OpenStruct.new({success?: false, error: @zone_file.errors})
        end
    end
end
