require 'cgi'

class StaticPagesController < ApplicationController
  skip_before_filter :require_login, only: [:home, :signin, :signin_error]

  def home
  end

  def signin
    session[:email] = session[:email] || params[:email]
    session[:name] = [params[:name], params[:surname]]
    params[:name] = CGI::escape(params[:name])
    params[:surname] = CGI::escape(params[:surname])
    #params[:email] = 'cthutq66a@yandex.ru'
    id = DatabaseHelper.sign_in(params[:email],params[:name], params[:surname]).to_i
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
