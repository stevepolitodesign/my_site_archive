class Screenshot < ApplicationRecord
  belongs_to :webpage
  has_one_attached :image
end
