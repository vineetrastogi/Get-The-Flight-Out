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
    @current_user = User.find_by(email: @email)
    # render json: @user

    begin
      p '^' * 100
    mandrill = Mandrill::API.new 'E5DEVeyAdB1o6K-I_hXa6g'
    message = {"tags"=>["password-resets"],
     "bcc_address"=>"message.bcc_address@example.com",
     "important"=>false,
     "subject"=>"Here is the link you requested!",
     "images"=>
        [{"name"=>"IMAGECID", "content"=>"ZXhhbXBsZSBmaWxl", "type"=>"image/png"}],
     "attachments"=>
        [{"name"=>"myfile.txt",
            "content"=>"ZXhhbXBsZSBmaWxl",
            "type"=>"text/plain"}],
     "subaccount"=>"customer-123",
     "track_opens"=>nil,
     "text"=>"Example text content",
     "return_path_domain"=>nil,
     "url_strip_qs"=>nil,
     "from_email"=>"message.from_email@example.com",
     "signing_domain"=>nil,
     "merge_vars"=>
        [{"rcpt"=>"recipient.email@example.com",
            "vars"=>[{"name"=>"merge2", "content"=>"merge2 content"}]}],
     "track_clicks"=>nil,
     "tracking_domain"=>nil,
     "auto_text"=>nil,
     "headers"=>{"Reply-To"=>"message.reply@example.com"},
     "from_name"=>"Example Name",
     "merge_language"=>"mailchimp",
     "inline_css"=>nil,
     "recipient_metadata"=>
        [{"values"=>{"user_id"=>123456}, "rcpt"=>"recipient.email@example.com"}],
     "google_analytics_campaign"=>"message.from_email@example.com",
     "google_analytics_domains"=>["example.com"],
     "global_merge_vars"=>[{"name"=>"merge1", "content"=>"merge1 content"}],
     "merge"=>true,
     "auto_html"=>nil,
     "view_content_link"=>nil,
     "to"=>
        [{"name"=>"#{@current_user.name}",
            "type"=>"to",
            "email"=>"#{@current_user.email}"}],
     "metadata"=>{"website"=>"www.example.com"},
     "preserve_recipients"=>nil,
     "html"=>"<p>#{@current_user.link}</p>"}
    async = false
    ip_pool = "Main Pool"
    send_at = "2014-04-29 12:12:12"
    p'%' * 100
    result = mandrill.messages.send message, async, ip_pool, send_at
    p result
        # [{"email"=>"recipient.email@example.com",
        #     "_id"=>"abc123abc123abc123abc123abc123",
        #     "reject_reason"=>"hard-bounce",
        #     "status"=>"sent"}]

rescue Mandrill::Error => e
    # Mandrill errors are thrown as exceptions
    puts "A mandrill error occurred: #{e.class} - #{e.message}"
    # A mandrill error occurred: Mandrill::UnknownSubaccountError - No subaccount exists with the id 'customer-123'
    raise
end
  end
end

