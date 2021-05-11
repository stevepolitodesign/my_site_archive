class ImageAttacherJob < ApplicationJob
  queue_as :default

  def perform(website_id)
    @website = Website.find_by(id: website_id)
    return if @website.nil?
    # OPTIMIZE: Refactor this to use Browserless
    capture_screenshot_and_attach_image
  end

  private

    def attach_image(file)
      result = ImageAttacher.new(@website, file, "image").call
      TmpFileRemover.new(file).call if result.success?
    end

    def capture_screenshot
      ScreenshotCapturer.new(@website.url).call
    end

    def capture_screenshot_and_attach_image
      result = capture_screenshot
      attach_image(result.payload) if result.success?
    end

end
