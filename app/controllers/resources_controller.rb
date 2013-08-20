class ResourcesController < ApplicationController
  include ResourcesHelper

  def create
    # Create resource
    resource_info = params[:resource]
    id = session[:user_id]
    tags = DatabaseHelper.tags(id)
    resource = resourceInfoToResource(resource_info, tags, id)

    if resource.valid?
      DatabaseHelper.add_resource(resource)
    else
      @errors_array = resource.errors.full_messages
    end
    redirect_to :back, flash: { errors: @errors_array }

  end

  def index
    # 'Index' page - list of all resources and options
    @errors_array = flash[:errors]
    @id = session[:user_id]
    @tags = DatabaseHelper.tags(@id)
    @selected_tags = nil # { tags: '1,2,3' }
    @resources = DatabaseHelper.resources(@id, @selected_tags)
    @name = session[:name][0]
  end

  def show
    resource_id = params[:id]
    id = session[:user_id]
    @resource = DatabaseHelper.get_resource(id, resource_id)
    @tag_string = get_tags_string(@resource, DatabaseHelper.tags(id))
  end

  def edit
    resource_id = params[:id]
    id = session[:user_id]
    @resource = DatabaseHelper.get_resource(id, resource_id)
    @tag_string = get_tags_string(@resource, DatabaseHelper.tags(id))
  end

  def update
    id = session[:user_id]
    resource_info = params[:resource]
    resource_info[:id] = params[:id]
    resource_info[:user_id] = id
    tags = DatabaseHelper.tags(id)
    DatabaseHelper.edit_resource(resourceInfoToResource(resource_info, tags, id))
    redirect_to action: :index
  end

  def destroy
    result = DatabaseHelper.delete_resource(session[:user_id], params[:id])
    redirect_to action: :index
  end

  def filter
    selected_tag = params[:id]
    selected_tags = session[:selected_tags]
    if selected_tags.include? selected_tag
      selected_tags.delete selected_tag
    else
      selected_tags.unshift selected_tag
    end
    session[:selected_tags] = selected_tags
    redirect_to :back, flash: { new_tag: selected_tag }
  end

end
