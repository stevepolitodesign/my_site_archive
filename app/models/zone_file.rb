class ZoneFile < ApplicationRecord
  belongs_to :website
  has_many :dns_records, dependent: :destroy

  after_create_commit :broadcast_later

  private

    def broadcast_later
      sleep 3
      if self.website.archive.present?
        self.broadcast_action_to(
          [self.website.user, :zone_files],
          action: :replace,
          target: "archive_zone_file",
          partial: "zone_files/zone_file",
          locals: { zone_file:  self, link_to_index: false, headline: "Current DNS Records" },
        )        
      else
        self.broadcast_action_to(
          [self.website.user, :zone_files],
          action: :replace,
          target: "archive_zone_file",
          partial: "zone_files/zone_file",
          locals: { zone_file:  self, link_to_index: true, headline: "Current DNS Records" },
        )
      end
    end
end
