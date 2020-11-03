class ScreenshotCreator
    def initialize(webpage_id, file)
        @webpage_id = webpage_id
        @file       = file
    end

    def call
        begin
            set_webpage
            build_screenshot
            attach_screenshot
            @screenshot = save_screenshot
            OpenStruct.new({ success?: true, payload: @screenshot })
        rescue => error
            OpenStruct.new({ success?: false, error: error })
        end
    end

    private

        attr_reader :webpage_id

        def set_webpage
            @webpage = Webpage.find_by(id: webpage_id)
        end

        def build_screenshot
            @screenshot = @webpage.screenshots.build
        end

        def attach_screenshot
            @screenshot.image.attach(io: File.open(@file), filename: "#{@webpage.url.parameterize}.png")
        end

        def save_screenshot
            @screenshot.save
        end
end