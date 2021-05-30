class Screenshot < ApplicationRecord
  belongs_to :webpage
  has_one :html_document, dependent: :destroy
  has_one :stat, dependent: :destroy
  has_one_attached :image

  broadcasts_to ->(screenshot) { [ screenshot.webpage.website.user, :screenshots ] }, inserts_by: :replace
end
