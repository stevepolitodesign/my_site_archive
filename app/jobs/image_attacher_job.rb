class ImageAttacherJob < Browserless::BaseJob
  queue_as :default

  before_perform :configure_capybara
  before_perform :set_website

  def perform(website_id)
    return if @website.nil?
    capture_screenshot_and_attach_image(@website.url)
  end

  private

    # OPTIMIZE: This can probaby be extracted into Browserless::BaseJob, and merged with capture_and_create_screenshot_and_html_document
    def capture_screenshot_and_attach_image(url)
      directory   = create_temporary_screenshot_directory
      file_name   = path_to_screenshot(directory, url)
      browser     = Capybara.current_session
      browser.visit url
      screenshot  = browser.save_screenshot(file_name, full: true)
      @website.image.attach(io: File.open(screenshot), filename: file_name.split("/").last)
      TmpFileRemover.new(file_name).call
      browser.driver.quit
      @website.save
    end

    def set_website
      @website = Website.find_by(id: arguments.first)
    end

end
