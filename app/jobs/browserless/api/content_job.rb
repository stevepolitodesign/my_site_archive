require 'net/http'
require 'uri'

class Browserless::Api::ContentJob < ApplicationJob
  queue_as :default

  def perform(url)
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
    res.body
  end
end
