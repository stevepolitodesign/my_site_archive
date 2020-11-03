class CreateZoneFileJob < ApplicationJob
  queue_as :default

  def perform(website_id)
    @website = Website.find_by(id: website_id)
    return if @website.nil?
    result = ZoneFileCreator.new(@website).call
    if result.success?
      @zone_file = result.payload
      CreateDnsRecordsJob.perform_later(@zone_file.id)
    else
      return
    end
  end
end
