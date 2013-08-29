require 'cgi'
require 'google/api_client'

class StaticPagesController < ApplicationController
  skip_before_filter :require_login, only: [:home, :signin, :signin_error]

  def home
    session[:redirect_url] = flash[:redirect_url]
  end

  def signin

    client = Google::APIClient.new
    plus = client.discovered_api('plus')
    client.authorization.client_id = ENV['CLIENT_ID']
    client.authorization.client_secret = ENV['CLIENT_SECRET']
    client.authorization.scope = 'https://www.googleapis.com/auth/plus.login https://www.googleapis.com/auth/userinfo.email'
    client.authorization.redirect_uri = signin_url;

    client.authorization.code = params[:code]
    client.authorization.fetch_access_token!

    user_name = client.execute(
        :api_method => plus.people.get,
        :parameters => {'userId' => 'me'},
        :authenticated => true
    ).data['name']
    user_name['given_name'] = user_name['given_name']
    user_name['family_name'] = user_name['family_name']
    user_info = HTTParty.get('https://www.googleapis.com/oauth2/v2/userinfo?access_token=' + client.authorization.access_token)
    user = DatabaseHelper.sign_in(user_info['email'],user_name['given_name'], user_name['family_name'])
    if user
      session[:user] = user
      session[:last_update] = 0
      true_path, session[:redirect_url] = session[:redirect_url] || resources_path, nil
      redirect_to true_path
    else
      redirect_to action: :signin_error
    end
  end

  def signin_error
  end

  def about
  end
end
