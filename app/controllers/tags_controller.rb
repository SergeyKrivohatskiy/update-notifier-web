class TagsController < ApplicationController
  include TagsHelper

  def create
    id = session[:user_id]
    tag_string = params[:tag][:name]
    tags = add_new_tags(tag_string,id)

    #redirect_to :back, flash: { errors: errors_array }
    redirect_to :back
  end

  def destroy
    result = DatabaseHelper.delete_tag(session[:user_id], params[:id])
    #session[:tags] = session[:tags].delete(params[:id]) if result
    redirect_to :back
  end

end