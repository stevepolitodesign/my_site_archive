class CreateDnsRecordsJob < ApplicationJob
  queue_as :default

  def perform(zone_file_id)
    @zone_file = ZoneFile.find_by(id: zone_file_id)
    return if @zone_file.nil?
    DnsRecord.record_types.keys.each do |record_type|
      retrieve_dns_records(@zone_file.id, @zone_file.website.url, record_type)
    end
  end

  private

    def retrieve_dns_records(zone_file_id, address, record_type)
      result = DnsRecordRetriever.new(address, record_type).call
      if result.success?
        # CreateDnsRecordJob.perform_later(zone_file_id, result.payload)
        CreateDnsRecordJob.perform_now(zone_file_id, result.payload)
      else
        return
      end
    end
end
