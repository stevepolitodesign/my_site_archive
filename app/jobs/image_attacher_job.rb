class ImageAttacherJob < ApplicationJob
  queue_as :default

  before_perform :set_website

  def perform(website_id)
    return if @website.nil?
    capture_screenshot_and_attach_image(@website.url)
  end

  private

    def capture_screenshot_and_attach_image(url)
      image =  Browserless::Api::ScreenshotJob.perform_now(url)
      @website.image.attach(io: image, filename: @website.generate_file_name)
      @website.save
    end

    def set_website
      @website = Website.find_by(id: arguments.first)
    end

end
