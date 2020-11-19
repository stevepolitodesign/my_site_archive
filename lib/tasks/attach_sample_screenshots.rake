namespace :attach_sample_screenshots do
  desc "TODO"
  task perform: :environment do
    Screenshot.all.each { |screenshot| screenshot.image.attach(io: File.open(Rails.root.join("test/fixtures/files/1000x1000.png")), filename: '1000x1000.png' ) }
  end
end
