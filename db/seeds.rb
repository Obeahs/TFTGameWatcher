# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# db/seeds.rb

# Fetch account using Riot ID
account_data = RiotApiService.get_account_by_riot_id('your_game_name', 'NA1')
if account_data['status'].nil?
  puuid = account_data['puuid']

  # Create Users
  user = User.create!(
    name: account_data['gameName'],
    riot_id: puuid
  )

  # Fetch match IDs for the user
  matches_data = RiotApiService.get_match_data('your_match_id') # Replace 'your_match_id' with actual match ID

  # Create Matches and associated data
  matches_data['matches'].each do |match|
    new_match = Match.create!(
      match_id: match['metadata']['match_id'],
      user: user,
      game_type: match['info']['game_type']
    )

    match['info']['participants'].each do |participant|
      new_participant = Participant.create!(
        match: new_match,
        participant_id: participant['puuid'],
        placement: participant['placement']
      )

      participant['units'].each do |unit|
        Unit.create!(
          participant: new_participant,
          character_id: unit['character_id'],
          tier: unit['tier'],
          items: unit['items'].join(',')
        )
      end
    end

    UserMatch.create!(user: user, match: new_match)

    # Assuming you have some logic to assign champions to matches
    MatchChampion.create!(
      match: new_match,
      champion_id: Faker::Number.between(from: 1, to: 10)
    )
  end

  puts "Seed data created successfully!"
else
  puts "Error: #{account_data['status']['message']}"
end
