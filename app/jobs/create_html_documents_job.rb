class CreateHtmlDocumentsJob < ApplicationJob
  queue_as :default

  before_perform :set_users

  def perform
    # TODO: Consider querying for all Webpages where the Website User is subscribed.
    @users.find_in_batches(batch_size: 100) do |group|
      group.each do |user|
        user.capture_new_html_documents
      end
    end
  end

  private

    def set_users
      @users = User.with_active_subscriptions.with_websites.includes(:websites)
    end
end
