class Archive
  include ActiveRecord::Associations
  include ActiveModel::Model

  attr_accessor :url, :user_id

  # TODO: Consider adding a validation to prevent anonymous users from running too many reports
  validates :user_id, :url, presence: true
  validates :user_id, numericality: { only_integer: true, greater_than: 0 }
  validates :url, url: true

  def generate_report
    # TODO: Trigger jobs to build archive.
  end
end