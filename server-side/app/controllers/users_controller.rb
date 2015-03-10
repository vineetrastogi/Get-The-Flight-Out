class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def create
    @user = User.create(name: params['name'], email: params['email'])
    render json: @user
  end
end
