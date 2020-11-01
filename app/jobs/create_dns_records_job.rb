require 'uri/http'

class CreateDnsRecordsJob < ApplicationJob
  queue_as :default

  def perform(zone_file_id)
    @zone_file = ZoneFile.find_by(id: zone_file_id)
    return if @zone_file.nil?
    DnsRecord.record_types.keys.each do |record_type|
      case record_type
      when "cname"
        retrieve_dns_records(
          @zone_file.id,
          url_with_subdomain_without_protocol(@zone_file.website.url),
          record_type
        )
      else
        retrieve_dns_records(
          @zone_file.id,
          url_without_protocol(@zone_file.website.url),
          record_type
        )
      end
    end
  end

  private

    def retrieve_dns_records(zone_file_id, address, record_type)
      result = DnsRecordRetriever.new(address, record_type).call
      if result.success?
        CreateDnsRecordJob.perform_now(zone_file_id, result.payload)
      else
        return
      end
    end

    def url_with_subdomain_without_protocol(url)
      uri = URI.parse(url)
      domain = PublicSuffix.parse(uri.host)
    end

    def url_without_protocol(url)
      url = url_with_subdomain_without_protocol(url)
      url.domain
    end
end
