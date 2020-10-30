class CreateDnsRecordJob < ApplicationJob
  queue_as :default

  def perform(zone_file_id, resources)
    @zone_file = ZoneFile.find_by(id: zone_file_id)
    return if @zone_file.nil?
    resources.each do |resource|
      DnsRecordCreator.new(@zone_file, resource).call
    end
  end
end
