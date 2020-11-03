class CreateScreenshotJob < ApplicationJob
  queue_as :default

  def perform(webpage_id)
    @webpage = Webpage.find_by(id: webpage_id)
    return if @webpage.nil?
    result = ScreenshotCapturer.new(@webpage.url).call
    if result.success?
      # TODO: Make this a service object.
      file_name = @webpage.url.parameterize
      @screenshot = @webpage.screenshots.build
      @screenshot.image.attach(io: File.open(result.payload), filename: file_name)
      @screenshot.save
    else
      return
    end
  end
end
