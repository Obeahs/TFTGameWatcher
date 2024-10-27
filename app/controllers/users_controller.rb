class UsersController < ApplicationController
  before_action :set_page_title

  def index
    if params[:search].present?
      @users = search_user(params[:search])
    else
      @users = User.includes(:matches).all
    end
  end

  def show
    @user = User.find(params[:id])
    @recent_matches = get_recent_matches(@user)
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

      # Use find_or_create_by to avoid duplicates
      user = User.find_or_create_by(riot_id: riot_id) do |u|
        u.puuid = puuid
      end

      # Return users that match the found PUUID, including their matches
      User.includes(:matches).where(puuid: puuid)
    else
      # Return an empty array if the API call fails
      []
    end
  end

  def get_recent_matches(user)
    match_ids = RiotApiService.get_matchlist_by_puuid(user.puuid)&.take(3) || []

    match_ids.map do |match_id|
      match_data = RiotApiService.get_match_data(match_id)
      if match_data.present?
        {
          metadata: match_data[:metadata]
        }
      end
    end.compact
  end
end
