class TagsController < ApplicationController
  include TagsHelper

  def create
    id = session[:user_id]
    tag_string = params[:tag][:name]
    tags = add_new_tags(tag_string, id)

    #redirect_to :back, flash: { errors: errors_array }
    redirect_to :back
  end

  def destroy
    id = session[:user_id]
    # TODO separate 'can't delete' and 'not found'?
    result = DatabaseHelper.delete_tag(id, params[:id])
    keys = DatabaseHelper.tags(id).keys
    #if result # do it if not found but not if can't delete
    @selected_tags = session[:selected_tags] || []
    @selected_tags.each do |item|
      @selected_tags.delete(item) if !(keys.include? item.to_i)
    end
    #end
    @tags = DatabaseHelper.tags(id)
    tag_str = tags_to_url_param(@selected_tags.dup)
    @resources = DatabaseHelper.resources(id, (tag_str.blank? ? nil : {tags: tag_str}))
    #session[:tags] = session[:tags].delete(params[:id]) if result
    #redirect_to :back
  end

end