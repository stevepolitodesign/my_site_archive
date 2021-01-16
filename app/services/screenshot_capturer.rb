class ScreenshotCapturer
   
    def initialize(url)
        @url        = url
        @directory  = create_directory
        @screenshot = path_to_screenshot(@directory)
    end
    
    def call
        browser = Ferrum::Browser.new(timeout: 60, process_timeout: 5)
        browser.goto(@url)
        browser.screenshot(path: @screenshot, full: true, quality: 60, format: "jpeg")
        browser.quit
        OpenStruct.new({ success?: true, payload: @screenshot })
    rescue Ferrum::Error => error
        OpenStruct.new({ success?: false, error: error })
    end

    private

        attr_reader :url
        
        def create_directory
            directory = File.join(Rails.root, 'tmp', 'screenshots')
            Dir.mkdir(directory) unless File.directory?(directory)
            return directory
        end

        def path_to_screenshot(directory)
            "#{directory}/#{url.parameterize}-#{Time.zone.now.to_s.parameterize}.jpeg"
        end
        
end