require 'net/http'
require 'json'

class RiotApiService
  RIOT_API_BASE_URL = 'https://americas.api.riotgames.com'
  SUMMONER_API_BASE_URL = 'https://na1.api.riotgames.com'

  def self.get_account_by_riot_id(game_name, tag_line = 'NA1')
    url = URI("#{RIOT_API_BASE_URL}/riot/account/v1/accounts/by-riot-id/#{game_name}/#{tag_line}?api_key=#{ENV['RIOT_API_KEY']}")
    response = Net::HTTP.get(url)
    JSON.parse(response)
  rescue StandardError => e
    puts "Error: #{e.message}"
    nil
  end  

  def self.get_summoner_by_puuid(puuid)
    url = URI("#{RIOT_API_BASE_URL }/riot/account/v1/accounts/by-puuid/#{puuid}?api_key=#{ENV['RIOT_API_KEY']}")
    response = Net::HTTP.get(url)
    JSON.parse(response)
  rescue StandardError => e
    puts "Error: #{e.message}"
  end

  def self.get_matchlist_by_puuid(puuid)
    url = URI("#{RIOT_API_BASE_URL}/tft/match/v1/matches/by-puuid/#{puuid}/ids?api_key=#{ENV['RIOT_API_KEY']}")
    response = Net::HTTP.get(url)
    JSON.parse(response)
  rescue StandardError => e
    puts "Error: #{e.message}"
  end

  def self.get_match_data(match_id)
    url = URI("#{RIOT_API_BASE_URL}/tft/match/v1/matches/#{match_id}?api_key=#{ENV['RIOT_API_KEY']}")
    response = Net::HTTP.get(url)
    JSON.parse(response)
  rescue StandardError => e
    puts "Error: #{e.message}"
  end
  
  def self.get_match_data_placements(match_id)
    url = URI("#{RIOT_API_BASE_URL}/tft/match/v1/matches/#{match_id}?api_key=#{ENV['RIOT_API_KEY']}")
    begin
      response = Net::HTTP.get(url)
      data = JSON.parse(response)
      {
        metadata: data['metadata']['match_id'],
        participants: data['info']['participants'].map do |participant|
          {
            puuid: participant['puuid'],
            placement: participant['placement']
          }
        end
      }
    rescue StandardError => e
      puts "Error: #{e.message}"
      { metadata: {}, participants: [] }
    end
  end
end
