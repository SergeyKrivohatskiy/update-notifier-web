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
    id = session[:user_id]
    result = DatabaseHelper.delete_tag(id, params[:id])
    if result
      selected_tags = session[:selected_tags] || []
      keys = DatabaseHelper.tags(id).keys
      selected_tags.each do |item|
        selected_tags.delete(item) if !(keys.include? item.to_i)
      end
    end
    #session[:tags] = session[:tags].delete(params[:id]) if result
    redirect_to :back
  end

end