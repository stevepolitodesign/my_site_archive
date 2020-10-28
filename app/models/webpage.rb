class Webpage < ApplicationRecord
  belongs_to :website
  has_many :screenshots, dependent: :destroy

  validates :title, :url, presence: true
  validates :url, url: true

  before_validation :set_url

  private

    def set_url
      self.url = self.website.url + url
    end
end
