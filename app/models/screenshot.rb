class Screenshot < ApplicationRecord
  belongs_to :webpage
  has_one :html_document, dependent: :destroy
  has_one :stat, dependent: :destroy
  has_one_attached :image

  # TODO: Ensure this is scoped to the current user. I need to make sure the latest screenshot created isn't rendered on the page.
  # It needs to be the user's screenshot.
  broadcasts_to ->(screenshot) { [ screenshot.webpage.website.user, :screenshots ] }, inserts_by: :replace
end
