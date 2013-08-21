require 'cgi'

class StaticPagesController < ApplicationController
  skip_before_filter :require_login, only: [:home, :signin, :signin_error]

  def home
  end

  def signin
    params[:name] = CGI::escape(params[:name])
    params[:surname] = CGI::escape(params[:surname])
    #params[:email] = 'cthutq66a@yandex.ru'
    user = DatabaseHelper.sign_in(params[:email],params[:name], params[:surname])
    if user
      session[:user] = user
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
