class ImageAttacherJob < ApplicationJob
  queue_as :default

  def perform(website_id)
    @website = Website.find_by(id: website_id)
    return if @website.nil?
    capture_screenshot_and_attach_image
  end

  private

    def attach_image(file)
      ImageAttacher.new(@website, file, "image").call
      TmpFileRemover.new(file).call
    end

    def capture_screenshot
      ScreenshotCapturer.new(@website.url).call
    end

    def capture_screenshot_and_attach_image
      result = capture_screenshot
      attach_image(result.payload) if result.success?
    end

end
