class CreateDnsRecordsJob < ApplicationJob
  queue_as :default

  def perform(zone_file_id)
    @zone_file = ZoneFile.find_by(id: zone_file_id)
    return if @zone_file.nil?
    DnsRecord.record_types.keys.each do |record_type|
      retreive_dns_records(@zone_file.website.url, record_type)
    end
  end

  private

    def retreive_dns_records(zone_file_id, address, record_type)
      result = DnsRecordRetriever.new(address, record_type)
      if result.success?
        CreateDnsRecord.perform_later(zone_file_id, result)
      else
        return
      end
    end
end
