class ResourcesController < ApplicationController
  include ResourcesHelper
  include TagsHelper

  def create
    id = session[:user_id]
    tags = DatabaseHelper.tags(id)
    resource_info = params[:resource]
    resource_info[:tags] = add_new_tags(resource_info[:tags], id)
    resource_info[:schedule_code] = ResourcesHelper.schedule_codes.index(resource_info[:schedule_code])
    resource = Resource.new(resource_info)
    resource.user_id = id

    if resource.valid?
      DatabaseHelper.add_resource(resource)
      @tags = DatabaseHelper.tags(id)
      @selected_tags = session[:selected_tags] || []
      tag_str = tags_to_url_param(@selected_tags.dup)
      @resources = DatabaseHelper.resources(id, (tag_str.blank? ? nil : {tags: tag_str}))
    else
      @errors_array = resource.errors.full_messages
      render status: :bad_request, json: @errors_array
    end
  end

  def index
    @schedule_codes = ResourcesHelper.schedule_codes
    @errors_array = flash[:errors]
    user = session[:user]
    session[:user_id] = @id = user[:id]
    @name = user[:name]
    @tags = DatabaseHelper.tags(@id)

    @invert_tags = {}
    @tags.each_pair do |key, value|
      @invert_tags[value] = key
    end
    session[:selected_tags] ||= []
    @selected_tags = session[:selected_tags] || []

    tag_str = tags_to_url_param(@selected_tags.dup)
    @resources = DatabaseHelper.resources(@id, (tag_str.blank? ? nil : {tags: tag_str}))
    session[:last_update] =  session[:last_update] || Time.new.to_s
  end

  def edit
    resource_id = params[:id]
    id = session[:user_id]
    @resource = DatabaseHelper.get_resource(id, resource_id)
    @resource.tags = get_tags_string(@resource, DatabaseHelper.tags(id))
    @schedule_codes = ResourcesHelper.schedule_codes
    @schedule_code = schedule_code_to_s(@resource.schedule_code)
  end

  def update
    id = session[:user_id]
    tags = DatabaseHelper.tags(id)
    resource_info = params[:resource]
    if resource_info
      resource_info[:tags] = add_new_tags(resource_info[:tags], id)
      resource_info[:id] = params[:id]
      resource_info[:user_id] = id
      resource_info[:schedule_code] = ResourcesHelper.schedule_codes.index(resource_info[:schedule_code])
      resource = Resource.new(resource_info)
      if resource.valid?
        DatabaseHelper.edit_resource(resource)
        @tags = DatabaseHelper.tags(id)
        selected_tags = session[:selected_tags] || []
        tag_str = tags_to_url_param(selected_tags.dup)
        @resources = DatabaseHelper.resources(id, (tag_str.blank? ? nil : {tags: tag_str}))
      else
        @errors_array = resource.errors.full_messages
        render status: :bad_request, json: @errors_array
      end
    end
    #redirect_to action: :index
  end

  def check_update
    res_id = DatabaseHelper.get_updated(session[:user_id], { time: session[:last_update] })
    session[:last_update] = Time.new.to_s
    if res_id
      render json: res_id
    end
  end

  def destroy
    id = session[:user_id]
    result = DatabaseHelper.delete_resource(id, params[:id])
    if result
      @tags = DatabaseHelper.tags(id)
      selected_tags = session[:selected_tags] || []
      tag_str = tags_to_url_param(selected_tags.dup)
      @resources = DatabaseHelper.resources(id, (tag_str.blank? ? nil : {tags: tag_str}))
    end
  end

  def filtered_by
    unless params[:tag_id].blank?
      selected_tag = params[:tag_id].to_i
      if selected_tag > 0
        selected_tags = session[:selected_tags]
        selected_tags = [] unless selected_tags
        if selected_tags.include? selected_tag
          selected_tags.delete selected_tag
        else
          selected_tags.unshift selected_tag
        end
      end
      #redirect_to :back
    end
    id = session[:user_id]
    @selected_tags = session[:selected_tags] || []
    @tags = DatabaseHelper.tags(id)
    tag_str = tags_to_url_param(@selected_tags.dup)
    @resources = DatabaseHelper.resources(id, (tag_str.blank? ? nil : {tags: tag_str}))

  end

end
