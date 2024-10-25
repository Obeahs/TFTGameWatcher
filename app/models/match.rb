class Match < ApplicationRecord
  belongs_to :user
  has_many :participants
  has_many :user_matches
  has_many :users, through: :user_matches
  has_many :match_champions

  validates :match_id, presence: true, uniqueness: true
  validates :game_type, presence: true
end
