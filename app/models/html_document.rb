class HtmlDocument < ApplicationRecord
  belongs_to :webpage

  validates :source_code, presence: true
end
