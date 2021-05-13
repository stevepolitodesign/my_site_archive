class ImageAttacherJob < ApplicationJob
  queue_as :default

  before_perform :set_website

  def perform(website_id)
    return if @website.nil?
    capture_screenshot_and_attach_image(@website.url)
  end

  private

    def capture_screenshot_and_attach_image(url)
      # TODO: Make this a separate job
      uri = URI("https://chrome.browserless.io/screenshot?token=#{Rails.application.credentials.dig(:browserless, :private_key) }")
      res = Net::HTTP.post(
        uri,
        {
          "url" => "#{url}",
          "options" => {
            "fullPage" => "true",
            "type" => "png",
          }
        }.to_json,
        {
          "Content-Type" => "application/json",
          "Cache-Control" => "no-cache"
        }
      )
      image = StringIO.new(res.body)
      @website.image.attach(io: image, filename: @website.generate_file_name)
      @website.save
    end

    def set_website
      @website = Website.find_by(id: arguments.first)
    end

end
