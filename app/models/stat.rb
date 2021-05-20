class Stat < ApplicationRecord
  SCORES = %i[performance accessibility best_practices seo pwa]

  store :score, accessors: SCORES
  belongs_to :screenshot
end
