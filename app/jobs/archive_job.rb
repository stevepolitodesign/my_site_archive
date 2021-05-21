class ArchiveJob < ApplicationJob
  # TODO: Consider lowering the priority.
  queue_as :default

  def perform(website, original_url)
    website.capture_new_zone_file
    webpage = website.webpages.create(url: original_url, title: original_url)
    webpage.capture_new_screenshot
    website
  end
end
