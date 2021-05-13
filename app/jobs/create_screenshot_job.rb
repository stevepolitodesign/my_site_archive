require 'stringio'
require 'net/http'
require 'uri'
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
      # TODO: Make this a separate job
      uri = URI("https://chrome.browserless.io/screenshot?token=#{Rails.application.credentials.dig(:browserless, :private_key) }")
      res = Net::HTTP.post(
        uri,
        {
          "url" => "#{url}",
          "options" => {
            "fullPage" => "true",
            "type" => "png",
          }
        }.to_json,
        {
          "Content-Type" => "application/json",
          "Cache-Control" => "no-cache"
        }
      )
      image         = StringIO.new(res.body)
      @screenshot = @webpage.screenshots.build
      @screenshot.image.attach(io: image, filename: @screenshot.generate_file_name)
      # TODO: Make this a separate job
      uri = URI("https://chrome.browserless.io/content?token=#{Rails.application.credentials.dig(:browserless, :private_key) }")
      res = Net::HTTP.post(
        uri,
        {
          "url" => "#{url}",
        }.to_json,
        {
          "Content-Type" => "application/json",
          "Cache-Control" => "no-cache"
        }
      )
      @screenshot.create_html_document(source_code: res.body) if @screenshot.save
      @screenshot
    end

    def set_webpage
      @webpage = Webpage.find_by(id: arguments.first)
    end

end
