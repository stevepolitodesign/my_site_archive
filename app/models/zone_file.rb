class ZoneFile < ApplicationRecord
  belongs_to :website
  has_many :dns_records, dependent: :destroy
end
