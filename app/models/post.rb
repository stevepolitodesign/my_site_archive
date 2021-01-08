class Post < ApplicationRecord
    extend FriendlyId
    
    scope :published, -> { where(status: :published) }
    enum status: [:draft, :published]

    validates :status, :title, presence: true

    has_rich_text :content
    friendly_id :title, use: :slugged
end
