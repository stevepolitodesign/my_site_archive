class CreateScreenshotJob < ApplicationJob
  queue_as :default

  def perform(webpage_id)
    @webpage = Webpage.find_by(id: webpage_id)
    return if @webpage.nil?
    result = ScreenshotCapturer.new(@webpage.url).call
    if result.success?
      screenshot = result.payload
      result = ScreenshotCreator.new(webpage_id, screenshot).call
      if result.success?
        @screenshot = result.payload
        CreateHtmlDocumentJob.perform_later(@screenshot.id)
      end
      TmpFileRemover.new(screenshot).call
    else
      return
    end
  end
end
