class Archive
  include ActiveModel::Model
  include Domainable

  attr_accessor :url, :user_id

  # TODO: Consider adding a validation to prevent anonymous users from running too many reports
  validates :user_id, :url, presence: true
  validates :user_id, numericality: { only_integer: true, greater_than: 0 }
  validates :url, url: true

  def generate_report
    ActiveRecord::Base.transaction do
      domain = remove_path_from_url
      @website = Website.new(url: domain, title: domain, user_id: user_id)
      @website.save!(validate: false)
      @website.capture_new_zone_file
      @webpage = @website.webpages.create(url: url, title: url)
      @webpage.capture_new_screenshot
      @website
    end
  end


end