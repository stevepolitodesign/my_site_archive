class HtmlDocument < ApplicationRecord
  belongs_to :screenshot

  validates :source_code, presence: true
end
