class ZoneFile < ApplicationRecord
  belongs_to :website
  has_many :dns_records, dependent: :destroy

  after_create_commit :broadcast_later

  private

    def broadcast_later
      self.broadcast_action_to(
        [self.website.user, :zone_files],
        action: :replace,
        target: "website_#{self.website.id}_zone_file",
        partial: "zone_files/zone_file",
        locals: { zone_file:  self, link_to_index: true, headline: "Current DNS Records" },
      )
    end  
end
