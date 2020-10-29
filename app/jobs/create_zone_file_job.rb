class CreateZoneFileJob < ApplicationJob
  queue_as :default

  def perform(website_id)
    @website = Website.find_by(website_id)
    if @website.present?
      result = ZoneFileCreator.new(@website).call
      if result.success?
        # TODO: Go through each of the DnsRecord.record_type.keys and create a DnsRecord for each record_type and each result
      else
        return
      end
    end
  end
end
