class UsersController < ApplicationController
  before_action :set_page_title

  def index
    @page_title = "Users"
    if params[:search].present?
      @users = search_user(params[:search])
    else
      @users = User.includes(:matches).all
    end
  end

  def show
    @user = User.find(params[:id])
    @page_title = "Profile - #{@user.riot_id}"
    @recent_matches = get_recent_matches(@user)
    @average_placement = calculate_average_placement(@recent_matches)
  end

  def match_data
    @match = RiotApiService.get_match_data(params[:id])
    Rails.logger.debug("Match data: #{@match.inspect}")
  
    if @match['metadata'].nil?
      Rails.logger.debug("Metadata is missing.")
      @page_title = "Match Details"
    else
      @page_title = "Match Details - #{@match['metadata']}"
    end
  
    if @match['info']['participants'].present?
      @participants = @match['info']['participants'].map do |participant|
        user = User.find_or_initialize_by(puuid: participant['puuid'])
        if user.new_record?
          summoner_data = RiotApiService.get_summoner_by_puuid(participant['puuid'])
          Rails.logger.debug("Fetched Summoner Data: #{summoner_data.inspect}")
          if summoner_data && summoner_data['gameName']
            user.riot_id = summoner_data['gameName']
            if user.save
              Rails.logger.debug("User saved successfully: #{user.inspect}")
            else
              Rails.logger.debug("User save failed: #{user.errors.full_messages}")
            end
          else
            Rails.logger.debug("No valid summoner data for PUUID: #{participant['puuid']}")
          end
        end
        participant.merge!('riot_id' => user.riot_id)
      end
    else
      @participants = []
      Rails.logger.debug("No participants data available.")
    end
    
    Rails.logger.debug("Participants with Riot IDs: #{@participants.inspect}")
    render 'match_data'
  end
  

  def load_more_matches
    @user = User.find(params[:id])
    offset = params[:offset].to_i
    additional_matches = get_recent_matches(@user, offset)
    render partial: "matches_table_rows", locals: { matches: additional_matches }
  end

  private

  def set_page_title
    @page_title = "Users"
  end

  def search_user(game_name)
    account_data = RiotApiService.get_account_by_riot_id(game_name)
    if account_data
      puuid = account_data['puuid']
      riot_id = account_data['gameName']
      user = User.find_or_create_by(riot_id: riot_id) do |u|
        u.puuid = puuid
      end
      User.includes(:matches).where(puuid: puuid)
    else
      []
    end
  end

  def get_recent_matches(user)
    match_ids = RiotApiService.get_matchlist_by_puuid(user.puuid).take(10)
    match_ids.map do |match_id|
      match_data = RiotApiService.get_match_data_placements(match_id)
      {
        metadata: match_data[:metadata],
        placement: match_data[:participants].find { |p| p[:puuid] == user.puuid }&.dig(:placement)
      }
    end
  end
  
  def calculate_average_placement(matches)
    total_placement = matches.sum { |match| match[:placement].to_i }
    total_placement / matches.size.to_f
  end
end  
