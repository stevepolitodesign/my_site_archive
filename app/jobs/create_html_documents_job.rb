class CreateHtmlDocumentsJob < ApplicationJob
  queue_as :default

  def perform
    Webpage.with_active_subscribers.each do |webpage|
      webpage.capture_new_html_document if webpage.should_capture_new_html_document?
    end
  end
end
