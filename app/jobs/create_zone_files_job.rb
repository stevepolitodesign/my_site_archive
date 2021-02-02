class CreateZoneFilesJob < ApplicationJob
  queue_as :default

  def perform
    Website.with_active_subscribers.each do |website|
      website.capture_new_zone_file if website.should_capture_new_zone_file?
    end
    Website.with_on_going_free_trials.each do |website|
      website.capture_new_zone_file if website.should_capture_new_zone_file?
    end    
  end

end