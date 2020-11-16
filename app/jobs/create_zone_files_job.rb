class CreateZoneFilesJob < ApplicationJob
  queue_as :default

  def perform
    # TODO: Consider querying for all Websites where the User is subscribed. 
    Website.with_active_subscribers.each do |website|
      website.capture_new_zone_file if website.should_capture_new_zone_file?
    end
  end

end
