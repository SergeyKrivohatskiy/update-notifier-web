require 'database_helper'
class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :require_login

  def require_login
    unless session[:user]
      redirect_to(root_path, status: :see_other)
    #else
      #unless session[:user] == DatabaseHelper.
    end
  end
end
