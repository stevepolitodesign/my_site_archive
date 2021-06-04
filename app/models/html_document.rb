class HtmlDocument < ApplicationRecord
  belongs_to :screenshot

  validates :source_code, presence: true

  after_create_commit :broadcast_later

  private
  
    def broadcast_later
      self.broadcast_action_to(
        [self.screenshot.webpage.website.user, :html_documents],
        action: :replace,
        target: "archive_html_document",
        partial: "html_documents/html_document",
        locals: { screenshot: self.screenshot, html_document: self }
      )
    end  
end
