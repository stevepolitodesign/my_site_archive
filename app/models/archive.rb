class Archive
  include ActiveRecord::Associations
  include ActiveModel::Model

  attr_accessor :url, :user_id

  validates :user_id, :url, presence: true
  validates :user_id, numericality: { only_integer: true, greater_than: 0 }
  validates :url, url: true
end