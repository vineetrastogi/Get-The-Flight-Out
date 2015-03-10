class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def create
    p '$' * 100
    p params
    p '$' * 100
    @user = User.create(name: params['formData']['0']['value'], email: params['formData']['1']['value'], link: params['purchaseLinkForEmail'])
    render json: @user
  end
end
