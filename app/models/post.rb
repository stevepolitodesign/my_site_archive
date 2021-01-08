class Post < ApplicationRecord
    extend FriendlyId
    enum status: [:draft, :published]
    scope :published, -> { where(status: :published) }
    friendly_id :title, use: :slugged
    has_rich_text :content
end
