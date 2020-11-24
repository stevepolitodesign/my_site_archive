class ScreenshotCreator
    def initialize(webpage_id, file)
        @webpage_id = webpage_id
        @file       = file
        @webpage    = set_webpage
        @screenshot = build_screenshot
    end

    def call
        attach_screenshot
        @screenshot.save
        OpenStruct.new({ success?: true, payload: @screenshot.reload })
    rescue => error
        OpenStruct.new({ success?: false, error: error })
    end

    private

        attr_reader :webpage_id

        def set_webpage
            Webpage.find_by(id: webpage_id)
        end

        def build_screenshot
            @webpage.screenshots.build
        end

        def attach_screenshot
            @screenshot.image.attach(io: File.open(@file), filename: @file.split("/").last)
        end

        def save_screenshot
            @screenshot.save
        end
end