class Participant < ApplicationRecord
  belongs_to :match
end
class Participant < ApplicationRecord
  belongs_to :match
  has_many :units

  validates :participant_id, presence: true
  validates :placement, presence: true, numericality: { only_integer: true }
end
