class CreateScreenshotJob < Browserless::BaseJob
  queue_as :default

  before_perform :configure_capybara
  before_perform :set_webpage

  def perform(webpage_id)
    return if @webpage.nil?
    capture_and_create_screenshot_and_html_document(@webpage.url)
  end

  private
      
    def capture_and_create_screenshot_and_html_document(url)
      directory   = create_temporary_screenshot_directory
      file_name   = path_to_screenshot(directory, url)
      browser     = Capybara.current_session
      browser.visit url
      markup      = browser.html
      screenshot  = browser.save_screenshot(file_name, full: true)
      @screenshot = @webpage.screenshots.build
      @screenshot.image.attach(io: File.open(screenshot), filename: file_name.split("/").last)
      @screenshot.create_html_document(source_code: markup) if @screenshot.save
      browser.driver.quit
    end

    def set_webpage
      @webpage = Webpage.find_by(id: arguments.first)
    end

end
