class UsersController < ApplicationController
  def index
    @users = User.includes(:matches)
  end
end
