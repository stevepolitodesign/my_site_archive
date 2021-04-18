class Archive
  include ActiveModel::Model

  attr_accessor :url
  validates :url, url: true
end
