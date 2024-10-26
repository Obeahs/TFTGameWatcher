class UsersController < ApplicationController
  def index
    @page_title = "Home"
    @users = if params[:search]
               User.where('name LIKE ?', "%#{params[:search]}%")
             else
               User.all
             end
  end
end
