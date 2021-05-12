class ImageAttacherJob < ApplicationJob
  queue_as :default

  before_perform :set_website

  def perform(website_id)
    return if @website.nil?
    capture_screenshot_and_attach_image(@website.url)
  end

  private

    # OPTIMIZE: This can probaby be extracted into Browserless::BaseJob, and merged with capture_and_create_screenshot_and_html_document
    def capture_screenshot_and_attach_image(url)
      # TODO: Use Browslerless API 
      # https://docs.browserless.io/docs/content.html
      @website.image.attach(io: File.open(screenshot), filename: file_name.split("/").last)
      @website.save
    end

    def set_website
      @website = Website.find_by(id: arguments.first)
    end

end
