class Screenshot < ApplicationRecord
  belongs_to :webpage
  has_one :html_document, dependent: :destroy
  # TODO: Make sure the image is deleted when the record is deleted.
  has_one_attached :image
end
