class Post < ApplicationRecord
    attr_accessor :temporary_slug
    extend FriendlyId
    
    scope :published, -> { where(status: :published) }
    enum status: [:draft, :published]

    validates :status, :title, presence: true

    has_one_attached :featured_image
    has_rich_text :content
    friendly_id :temporary_slug, use: :history

    def should_generate_new_friendly_id?
        slug.blank? && title_changed?
    end
end
