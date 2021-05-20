class Stat < ApplicationRecord
  SCORE_METRICS = %i[performance accessibility best_practices seo pwa]

  store :score, accessors: SCORE_METRICS
  belongs_to :screenshot
end
