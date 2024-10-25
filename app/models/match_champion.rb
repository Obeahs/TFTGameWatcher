class MatchChampion < ApplicationRecord
  belongs_to :match

  validates :champion_id, presence: true, numericality: { only_integer: true }
end
