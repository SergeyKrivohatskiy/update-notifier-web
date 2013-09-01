class UserController < ApplicationController

  def index
    @message = flash[:message]
  end

end