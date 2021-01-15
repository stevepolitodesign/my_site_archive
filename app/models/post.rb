class Post < ApplicationRecord
    extend FriendlyId
    
    scope :published, -> { where(status: :published) }
    enum status: [:draft, :published]

    validates :status, :title, presence: true

    has_rich_text :content
    friendly_id :title, use: :history

    def should_generate_new_friendly_id?
        title_changed?
    end
end
