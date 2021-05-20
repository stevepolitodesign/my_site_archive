class Screenshot < ApplicationRecord
  belongs_to :webpage
  has_one :html_document, dependent: :destroy
  has_one :stat, dependent: :destroy
  has_one_attached :image
end
