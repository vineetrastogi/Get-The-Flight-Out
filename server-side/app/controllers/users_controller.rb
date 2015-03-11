Dotenv::Railtie.load
require 'mandrill'
class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def create
    p '$' * 100
    @user = User.create(name: params['formData']['0']['value'], email: params['formData']['1']['value'], link: params['purchaseLinkForEmail'])
    # @name = params['formData']['0']['value']
    @email = params['formData']['1']['value']
    # @link = params['purchaseLinkForEmail']
    @current_user = User.where(email: @email).last

    begin
      mandrill = Mandrill::API.new "#{ENV['MANDRILL_API']}"
      message = {
       :subject=> "The trip which you requested from Get the Flight Out",
       :from_name=> "Get The Flight Out",
       :text=>"",
       :to=>[
         {
           :email=> "#{@current_user.email}",
           :name=> "#{@current_user.name}"
         }
         ],
         :html=>"<html><h1>Hi, <strong>#{@current_user.name.capitalize}</strong>, here is the link you requested! #{@current_user.link}</h1></html>",
         :from_email=>"vineetrastogi@gmail.com",
         :send_at => "2014-04-29 12:12:12"
       }
       sending = mandrill.messages.send message
       puts sending

      rescue Mandrill::Error => e
    puts "A mandrill error occurred: #{e.class} - #{e.message}"
    raise
  end

  render json: @user
end
end

