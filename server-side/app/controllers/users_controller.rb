class UsersController < ApplicationController
  def index
    @users = User.all
    p params

  end

  def create
    p '*' * 50
    p params
    p '*' * 50
    @user = User.create(name: params['name'], email: params['email'])
    render json: @user
  end
end
