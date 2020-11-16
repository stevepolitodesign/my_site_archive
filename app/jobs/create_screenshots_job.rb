class CreateScreenshotsJob < ApplicationJob
  queue_as :default

  def perform
    Webpage.with_active_subscribers.each do |webpage|
      webpage.capture_new_screenshot if webpage.should_capture_new_screenshot?
    end
  end
end
