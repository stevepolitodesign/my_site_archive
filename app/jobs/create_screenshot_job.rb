class CreateScreenshotJob < ApplicationJob
  queue_as :default

  before_perform :set_webpage

  def perform(webpage_id)
    return if @webpage.nil?
    capture_and_create_screenshot_and_html_document
  end

  private
  
    def capture_screenshot
      ScreenshotCapturer.new(@webpage.url).call
    end

    def capture_and_create_screenshot
      result = capture_screenshot
      if result.present? && result.success?
        screenshot  = result.payload 
        result      = create_screenshot(screenshot)
        TmpFileRemover.new(screenshot).call if result.success?
        result
      else
        return 
      end
    end
    
    def create_html_document(screenshot_id)
      CreateHtmlDocumentJob.perform_later(screenshot_id)
    end
    
    def create_screenshot(screenshot)
      ScreenshotCreator.new(arguments.first, screenshot).call
    end
    
    def capture_and_create_screenshot_and_html_document
      result = capture_and_create_screenshot
      if result.present? && result.success?
        create_html_document(result.payload.id)
      else
        return
      end
    end

    def set_webpage
      @webpage = Webpage.find_by(id: arguments.first)
    end

end
