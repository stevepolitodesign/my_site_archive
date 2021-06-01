class HtmlDocument < ApplicationRecord
  belongs_to :screenshot

  validates :source_code, presence: true

  after_create_commit :broadcast_later

  private
  
    # TODO: Ensure this is scoped to the current user. I need to make sure the latest screenshot created isn't rendered on the page.
    # It needs to be the user's screenshot.
    def broadcast_later
      self.broadcast_action_to(
        [self.screenshot.webpage.website.user, :html_documents],
        action: :replace,
        target: "screenshot_#{self.screenshot.id}_html_document",
        partial: "html_documents/html_document",
        locals: { screenshot: self.screenshot}
      )
    end  
end
