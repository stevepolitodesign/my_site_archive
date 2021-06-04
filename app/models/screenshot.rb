class Screenshot < ApplicationRecord
  belongs_to :webpage
  has_one :html_document, dependent: :destroy
  has_one :stat, dependent: :destroy
  has_one_attached :image

  after_create_commit :broadcast_later

  private
  
    def broadcast_later
      if self.webpage.website.archive.present?
        self.broadcast_action_to(
          [self.webpage.website.user, :screenshots],
          action: :replace,
          target: "archive_screenshot",
          partial: "screenshots/screenshot",
        )
      else
        self.broadcast_action_to(
          [self.webpage.website.user, :screenshots],
          action: :replace,
          target: "archive_screenshot",
          partial: "screenshots/screenshot",
          layout: "screenshots/layouts/column",
        )
      end
    end
end
