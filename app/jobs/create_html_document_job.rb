require 'nokogiri'
require 'open-uri'

class CreateHtmlDocumentJob < ApplicationJob
  queue_as :default

  def perform(screenshot_id)
    @screenshot = Screenshot.find_by(id: screenshot_id)
    return if @screenshot.nil?
    @webpage = @screenshot.webpage
    document = Nokogiri::HTML(URI.open(@webpage.url))
    @screenshot.create_html_document(source_code: document.inner_html.to_s)
  end

end
