class UsersController < ApplicationController
  @page_title="Users"
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

  def search_user(game_name)
    account_data = RiotApiService.get_account_by_riot_id(game_name)
    puuid = account_data['puuid']
    riot_id = account_data['gameName']

    user = User.find_or_create_by(riot_id: riot_id) do |u|
      u.puuid = puuid
    end

    User.includes(:matches).where(puuid: puuid)
  end

  def get_recent_matches(user)
    match_ids = RiotApiService.get_matchlist_by_puuid(user.puuid)
    match_ids.take(3).map do |match_id|
      match = RiotApiService.get_match_data(match_id)
      {
        match_id: match_id,
        game_type: match[:metadata]['game_type'],
        created_at: Time.now # assuming match data doesn't contain timestamps, replace with actual field if exists
      }
    end
  end
end
