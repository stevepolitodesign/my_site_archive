class Screenshot < ApplicationRecord
  belongs_to :webpage
  has_one :html_document, dependent: :destroy
  has_one_attached :image

  validates :width, numericality: { only_integer: true, greater_than_or_equal_to: 320, less_than_or_equal_to: 3000, allow_nil: true }
end
