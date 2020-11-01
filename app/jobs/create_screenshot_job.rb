require 'capybara/dsl'

class CreateScreenshotJob < ApplicationJob
  include Capybara::DSL

  queue_as :default

  def perform(webpage_id)
    @webpage = Webpage.find_by(id: webpage_id)
    return if @webpage.nil?
    configure_capybara
    page.save_screenshot
  end

  private

    def configure_capybara
      Capybara.run_server = false
      Capybara.current_driver = :selenium_chrome_headless
      Capybara.app_host = @wepage.url
    end
end
