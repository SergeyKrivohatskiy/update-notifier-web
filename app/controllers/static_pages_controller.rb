require 'cgi'
require 'google/api_client'

class StaticPagesController < ApplicationController
  skip_before_filter :require_login, only: [:home, :signin, :signin_error]

  def home
  end

  def signin

    client = Google::APIClient.new
    plus = client.discovered_api('plus')
    client.authorization.client_id = ENV['CLIENT_ID']
    client.authorization.client_secret = 'oGTOac49uHQprrlcJrasB1v1'
    client.authorization.scope = 'https://www.googleapis.com/auth/plus.login https://www.googleapis.com/auth/userinfo.email'
    client.authorization.redirect_uri = signin_url;

    client.authorization.code = params[:code]
    client.authorization.fetch_access_token!



    result = client.execute(
        :api_method => plus.people.get,
        :parameters => {'userId' => 'me'},
        :authenticated => true
    )
    user_name = result.data['name']
    session[:email] = session[:email] || 'cthutq66a@yandex.ru'
    session[:name] = [user_name['given_name'], user_name['family_name']]
    id = DatabaseHelper.sign_in('cthutq66a@yandex.ru',user_name['given_name'], user_name['family_name']).to_i
    if id > 0
      session[:user_id] = id
      session[:last_update] = 0
      redirect_to resources_path
    else
      redirect_to action: :signin_error
    end
  end

  def signin_error
  end

  def about
  end
end
