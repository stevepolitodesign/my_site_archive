require 'net/http'
require 'uri'
class Browserless::Api::StatsJob < ApplicationJob
  queue_as :default

  def perform(url)
    uri = URI("https://chrome.browserless.io/stats?token=#{Rails.application.credentials.dig(:browserless, :private_key) }")
    res = Net::HTTP.post(
      uri,
      {
        "url" => "#{url}"
      }.to_json,
      {
        "Content-Type" => "application/json",
        "Cache-Control" => "no-cache"
      }
    )
    JSON.parse(res.body)
  end
end
