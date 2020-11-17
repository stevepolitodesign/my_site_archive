namespace :create_zone_files do
  desc "Capture zone files for websites."
  task perform: :environment do
    CreateZoneFilesJob.perform_later
  end
end
