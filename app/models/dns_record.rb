class DnsRecord < ApplicationRecord
  belongs_to :zone_file

  enum record_type: [:a, :aaaa, :cname, :mx, :ns, :txt]

  validates :content, :record_type, presence: true 
end
