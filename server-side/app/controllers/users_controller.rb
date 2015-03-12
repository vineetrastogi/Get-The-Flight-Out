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
       :subject=> "Get The Flight Out: Requested Link",
       :from_name=> "Get The Flight Out",
       :text=>"",
       :to=>[
         {
           :email=> "#{@current_user.email}",
           :name=> "#{@current_user.name}"
         }
         ],
         :inline_css=> true,
         :html=>"<html><style>#hi{background-color: #DDDDDD; border: 2px solid black; padding: 15px}</style><img src='http://i.imgur.com/I5Wywsw.png'/><br>Hello, <strong>#{@current_user.name.capitalize}</strong><p>The prices on our homepage were specifically for one way trips. Prices may vary slightly as well.</p><h3>Here is the link you requested:</h3><br><ul><div id='hi'>#{@current_user.link}</div></ul></html>",
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

