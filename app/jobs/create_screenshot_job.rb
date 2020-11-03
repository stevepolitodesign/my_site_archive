class CreateScreenshotJob < ApplicationJob
  queue_as :default

  def perform(webpage_id)
    @webpage = Webpage.find_by(id: webpage_id)
    return if @webpage.nil?
    result = ScreenshotCapturer.new(@webpage.url).call
    if result.success?
      result = ScreenshotCreator.new(webpage_id, result.payload).call
      # TODO: Delete temporary screenshot.
    else
      return
    end
  end
end
