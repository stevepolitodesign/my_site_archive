class ScreenshotCapturer
   
    def initialize(url)
        @url        = url
        @directory  = create_directory
        @screenshot = path_to_screenshot(@directory)
    end
    
    def call
        browser = Ferrum::Browser.new
        browser.goto(@url)
        browser.screenshot(path: @screenshot)
        browser.quit
        OpenStruct.new({ success?: true, payload: @screenshot })
    rescue => error
        OpenStruct.new({ success?: false, error: error })
    end

    private

        attr_reader :url
        
        def create_directory
            directory = File.join(Rails.root, 'tmp', 'screenshots')
            Dir.mkdir(directory) unless File.directory?(directory)
            return directory
        end
        
        # TODO: Make screenshot full page, and wider.
        def path_to_screenshot(directory)
            "#{directory}/#{url.parameterize}-#{Time.zone.now.to_s.parameterize}.png"
        end
        
end