class Screenshot < ApplicationRecord
  belongs_to :webpage
  has_one :html_document, dependent: :destroy
  has_one :stat, dependent: :destroy
  has_one_attached :image

  after_create_commit :broadcast_later

  private
  
    # TODO: Ensure this is scoped to the current user. I need to make sure the latest screenshot created isn't rendered on the page.
    # It needs to be the user's screenshot.
    def broadcast_later
      self.broadcast_action_to(
        [self.webpage.website.user, :screenshots],
        action: :replace,
        target: "screenshots",
        partial: "screenshots/screenshot",
        layout: "screenshots/layouts/column",
      )
    end
end
