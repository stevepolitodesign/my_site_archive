# TODO: I might be able to delete this
require 'capybara'
require 'selenium-webdriver'

class ScreenshotCapturer
   
  def initialize(url)
    @url        = url
  end
    
  def call
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

    browser = Capybara.current_session
    browser.visit @url
    puts browser.html
    browser.driver.quit
  end
        
end
