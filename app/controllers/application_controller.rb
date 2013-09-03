class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper

  before_filter :require_login

  def require_login
    unless session[:user]
      redirect_to(root_path, status: :see_other, flash: { redirect_url: request.original_url })
    end
  end
end
