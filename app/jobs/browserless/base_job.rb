require 'capybara'
require 'selenium-webdriver'

class Browserless::BaseJob < ApplicationJob
  queue_as :default

  private

    def configure_capybara
      Capybara.server = :puma, { Silent: true }

      Capybara.register_driver :remote_chrome do |app|
        Capybara::Selenium::Driver.new(app, {
          :browser              => :remote,
          :url                  => "https://#{Rails.application.credentials.dig(:browserless, :private_key)}@chrome.browserless.io/webdriver",
          :desired_capabilities => Selenium::WebDriver::Remote::Capabilities.chrome("goog:chromeOptions" => {
            # Set launch flags similar to puppeteer's for best performance
            "args" => [
              "--disable-background-timer-throttling",
              "--disable-backgrounding-occluded-windows",
              "--disable-breakpad",
              "--disable-component-extensions-with-background-pages",
              "--disable-dev-shm-usage",
              "--disable-extensions",
              "--disable-features=TranslateUI,BlinkGenPropertyTrees",
              "--disable-ipc-flooding-protection",
              "--disable-renderer-backgrounding",
              "--enable-features=NetworkService,NetworkServiceInProcess",
              "--force-color-profile=srgb",
              "--hide-scrollbars",
              "--metrics-recording-only",
              "--mute-audio",
              "--headless",
              "--no-sandbox"
            ]
          }),
        })
      end
      
      Capybara.default_driver = :remote_chrome
    end

    def create_temporary_screenshot_directory
      directory = File.join(Rails.root, 'tmp', 'screenshots')
      Dir.mkdir(directory) unless File.directory?(directory)
      return directory
    end

    def path_to_screenshot(directory, url)
      "#{directory}/#{url.parameterize}-#{Time.zone.now.to_s.parameterize}.png"
    end
end
