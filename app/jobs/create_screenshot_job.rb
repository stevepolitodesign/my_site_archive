require 'net/http'
class CreateScreenshotJob < ApplicationJob
  queue_as :default

  before_perform :set_webpage

  def perform(webpage_id)
    return if @webpage.nil?
    capture_and_create_screenshot_and_html_document(@webpage.url)
  end

  private
    
    # OPTIMIZE: This can probaby be extracted into Browserless::BaseJob, and merged with capture_screenshot_and_attach_image.
    def capture_and_create_screenshot_and_html_document(url)
      # TODO: Use Browslerless API 
      # https://docs.browserless.io/docs/content.html
      uri = URI("https://chrome.browserless.io/screenshot?token=#{Rails.application.credentials.dig(:browserless, :private_key) }")
      res = Net::HTTP.post(
        uri,
        {
          "url" => "#{url}",
          "options" => {
            "fullPage" => "true",
            "type" => "png"
          }
        }.to_json,
        {
          "Content-Type" => "application/json",
          "Cache-Control" => "no-cache"
        }
      )
      puts res.body
      byebug
      # TODO:
      # @browserless = Browserless.new(markup: markup, screenshot: screenshot)
      @screenshot = @webpage.screenshots.build
      @screenshot.image.attach(io: File.open(screenshot), filename: file_name.split("/").last)
      @screenshot.create_html_document(source_code: markup) if @screenshot.save
      TmpFileRemover.new(file_name).call
      @screenshot
    end

    def set_webpage
      @webpage = Webpage.find_by(id: arguments.first)
    end

end
