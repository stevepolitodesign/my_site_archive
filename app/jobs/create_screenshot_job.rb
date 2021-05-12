class CreateScreenshotJob < Browserless::BaseJob
  queue_as :default

  before_perform :configure_capybara
  before_perform :set_webpage

  def perform(webpage_id)
    return if @webpage.nil?
    capture_and_create_screenshot_and_html_document(@webpage.url)
  end

  private
    
    # OPTIMIZE: This can probaby be extracted into Browserless::BaseJob, and merged with capture_screenshot_and_attach_image.
    def capture_and_create_screenshot_and_html_document(url)
      directory   = create_temporary_screenshot_directory
      file_name   = path_to_screenshot(directory, url)
      browser     = Capybara.current_session
      browser.visit url
      # https://github.com/madebylotus/capybara-full_screenshot/blob/master/lib/capybara/full_screenshot/rspec_helpers.rb#L4
      width  = browser.execute_script("return Math.max(document.body.scrollWidth, document.body.offsetWidth, document.documentElement.clientWidth, document.documentElement.scrollWidth, document.documentElement.offsetWidth);")
      height = browser.execute_script("return Math.max(document.body.scrollHeight, document.body.offsetHeight, document.documentElement.clientHeight, document.documentElement.scrollHeight, document.documentElement.offsetHeight);")
      Capybara.current_session.current_window.resize_to(width+100, height+100)
      markup      = browser.html
      screenshot  = browser.save_screenshot(file_name, full: true)
      # TODO:
      # @browserless = Browserless.new(markup: markup, screenshot: screenshot)
      @screenshot = @webpage.screenshots.build
      @screenshot.image.attach(io: File.open(screenshot), filename: file_name.split("/").last)
      @screenshot.create_html_document(source_code: markup) if @screenshot.save
      TmpFileRemover.new(file_name).call
      browser.driver.quit
      @screenshot
    end

    def set_webpage
      @webpage = Webpage.find_by(id: arguments.first)
    end

end
