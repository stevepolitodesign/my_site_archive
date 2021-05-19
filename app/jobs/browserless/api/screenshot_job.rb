require 'stringio'
require 'net/http'
require 'uri'

class Browserless::Api::ScreenshotJob < ApplicationJob
  queue_as :default

  def perform(url, options={})
    width = options[:width] || Webpage.new.width
    byebug
    uri = URI("https://chrome.browserless.io/screenshot?token=#{Rails.application.credentials.dig(:browserless, :private_key) }")
    res = Net::HTTP.post(
      uri,
      {
        "url" => "#{url}",
        "options" => {
          "fullPage" => "true",
          "type" => "png",
          "width" => "#{width}"
        }
      }.to_json,
      {
        "Content-Type" => "application/json",
        "Cache-Control" => "no-cache"
      }
    )
    StringIO.new(res.body)
  end
end
