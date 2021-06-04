class DnsRecord < ApplicationRecord
  belongs_to :zone_file

  enum record_type: [:a, :aaaa, :cname, :mx, :ns, :txt]

  validates :content, :record_type, presence: true
  
  scope :ordered, -> { order(record_type: :asc) }
  scope :unique, -> { select(:content, :record_type, :priority).distinct }

  after_create_commit :broadcast_later

  private

    def broadcast_later
      self.broadcast_action_to(
        [self.zone_file.website.user, :dns_records],
        action: :append,
        target: "dns_records",
        partial: "dns_records/dns_record",
      )
    end
end
