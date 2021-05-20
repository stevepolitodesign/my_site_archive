class CreateScreenshotJob < ApplicationJob
  queue_as :default

  before_perform :set_webpage

  def perform(webpage_id)
    return if @webpage.nil?
    capture_and_create_screenshot_and_html_document_and_stats(@webpage.url)
  end

  private

    def capture_and_create_screenshot_and_html_document_and_stats(url)
      image   =  Browserless::Api::ScreenshotJob.perform_now(url)
      markup  =  Browserless::Api::ContentJob.perform_now(url)
      @screenshot = @webpage.screenshots.build
      @screenshot.image.attach(io: image, filename: @webpage.generate_file_name)
      @screenshot.create_html_document(source_code: markup) if @screenshot.save
      @screenshot
    end

    def set_webpage
      @webpage = Webpage.find_by(id: arguments.first)
    end

end
