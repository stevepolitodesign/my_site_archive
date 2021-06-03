class Stat < ApplicationRecord
  SCORES = %i[performance accessibility best_practices seo]

  store :score, accessors: SCORES
  belongs_to :screenshot

  after_create_commit :broadcast_later

  private
  
    # TODO: Ensure this is scoped to the current user. I need to make sure the latest screenshot created isn't rendered on the page.
    # It needs to be the user's screenshot.
    def broadcast_later
      self.broadcast_action_to(
        [self.screenshot.webpage.website.user, :stats],
        action: :replace,
        target: "archive_stat",
        partial: "stats/stat",
      )
    end
end
