class User < ApplicationRecord
  has_many :matches
  has_many :user_matches
  has_many :matches, through: :user_matches

  validates :riot_id, presence: true, uniqueness: true
  validates :puuid, presence: true, uniqueness: true
end
