require 'nokogiri'
require 'open-uri'

class CreateHtmlDocumentJob < ApplicationJob
  queue_as :default

  def perform(webpage_id)
    @webpage = Webpage.find_by(id: webpage_id)
    return if @webpage.nil?
    begin
      document = Nokogiri::HTML(URI.open(@webpage.url))
      @webpage.html_documents.create(source_code: document.inner_html.to_s)
    rescue => exception
      logger.fatal exception
    end
  end

end
