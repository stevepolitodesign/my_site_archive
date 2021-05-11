class CreateScreenshotJob < Browserless::BaseJob
  queue_as :default

  before_perform :configure_capybara
  before_perform :set_webpage

  def perform(webpage_id)
    return if @webpage.nil?
    capture_and_create_screenshot_and_html_document(@webpage)
  end

  private
      
    def capture_and_create_screenshot_and_html_document(webpage)
      browser = Capybara.current_session
      browser.visit webpage.url
      puts browser.html
      browser.driver.quit
    end

    def set_webpage
      @webpage = Webpage.find_by(id: arguments.first)
    end

end
