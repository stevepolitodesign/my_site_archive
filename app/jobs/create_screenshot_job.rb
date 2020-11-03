require 'capybara/dsl'

class CreateScreenshotJob < ApplicationJob
  include Capybara::DSL

  after_perform :configure_capybara

  queue_as :default

  def perform(webpage_id)
    @webpage = Webpage.find_by(id: webpage_id)
    return if @webpage.nil?
    # TODO: Break these up into smaller methods.
    visit @webpage.url
    directory = File.join(Rails.root, 'tmp', 'screenshots')
    Dir.mkdir(directory) unless File.directory?(directory)
    file_name = "#{@webpage.url.parameterize}.png"
    file_path = page.save_screenshot("#{directory}/#{@webpage.url.parameterize}.png")
    # TODO: Make this a service object.
    @screenshot = @webpage.screenshots.build
    @screenshot.image.attach(io: File.open(file_path), filename: file_name)
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
