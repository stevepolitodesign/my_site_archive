namespace :create_screenshots do
  desc "Capture screenshots for webpages."
  task perform: :environment do
    CreateScreenshotsJob.perform_later
  end
end
