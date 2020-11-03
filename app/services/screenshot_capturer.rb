require 'capybara/dsl'

class ScreenshotCapturer
    include Capybara::DSL
   
    def initialize(url)
        @url = url
    end
    
    def call
        configure_capybara
        create_directory
        visit_url
        screenshot = take_screenshot(create_directory)
        OpenStruct.new({ success?: true, payload: screenshot })
    rescue => error
        OpenStruct.new({ success?: false, error: error })
    end

    private

        attr_reader :url

        def configure_capybara
            Capybara.run_server = false
            Capybara.current_driver = :selenium_chrome_headless
            Capybara.app_host = url
        end
        
        def create_directory
            directory = File.join(Rails.root, 'tmp', 'screenshots')
            Dir.mkdir(directory) unless File.directory?(directory)
            return directory
        end

        def visit_url
            visit url
        end

        def take_screenshot(directory)
            file_name = "#{url.parameterize}.png"
            page.save_screenshot("#{directory}/#{url.parameterize}.png")
        end
        
end