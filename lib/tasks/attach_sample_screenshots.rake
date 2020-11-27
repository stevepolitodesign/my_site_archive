namespace :attach_sample_screenshots do
  desc "TODO"
  task perform: :environment do
    @users = User.where.not(email: "sample_user_with_pending_data@example.com")
    @users.each do |user|
      @websites = user.websites
      @websites.each do |website|
        website.image.attach(io: File.open(Rails.root.join("test/fixtures/files/1000x1000.png")), filename: 'webiste.png' )
        @webpages = website.webpages
        @webpages.each do |webpage|
          @screenshots = webpage.screenshots
          @screenshots.each { |screenshot| screenshot.image.attach(io: File.open(Rails.root.join("test/fixtures/files/1000x1000.png")), filename: '1000x1000.png' ) }
        end
      end
    end
  end
end
