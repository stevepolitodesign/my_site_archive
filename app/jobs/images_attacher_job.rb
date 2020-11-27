class ImagesAttacherJob < ApplicationJob
  queue_as :default

  def perform
    Website.with_active_subscribers.each do |website|
      website.capture_screenshot unless website.image.attached?
    end
  end
end
