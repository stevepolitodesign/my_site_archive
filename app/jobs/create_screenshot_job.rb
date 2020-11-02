require 'capybara/dsl'

class CreateScreenshotJob < ApplicationJob
  include Capybara::DSL

  around_enqueue :configure_capybara

  queue_as :default

  def perform(webpage_id)
    @webpage = Webpage.find_by(id: webpage_id)
    return if @webpage.nil?
    visit @webpage.url
    # TODO: Make this a service object.
    path = File.join Rails.root, 'tmp', 'screenshots'
    FileUtils.mkdir_p(path) unless File.exist?(path)
    file_path = page.save_screenshot(path)
    @screenshot = @webpage.screenshots.build
    @screenshot.image.attach(io: file_path)
    @screenshot.save
    # TODO: Delete file after save
  end

  private

    def configure_capybara
      Capybara.run_server = false
      Capybara.current_driver = :selenium_chrome_headless
      Capybara.app_host = @webpage.url
    end 
end
