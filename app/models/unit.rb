class Unit < ApplicationRecord
  belongs_to :participant

  validates :character_id, presence: true
  validates :tier, presence: true, numericality: { only_integer: true }
  validates :items, presence: true
end
