# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require 'faker'

account_data = RiotApiService.get_account_by_riot_id('Frogen', 'NA1')
puuid = account_data['puuid']

puts puuid

user = User.find_or_create_by!(riot_id: puuid) do |u|
  u.name = account_data['gameName']
end

puts user

match_ids = RiotApiService.get_matchlist_by_puuid(puuid)

puts "Frogen match data"
