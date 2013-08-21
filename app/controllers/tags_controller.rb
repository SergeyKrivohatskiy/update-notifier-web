class TagsController < ApplicationController
  def index
    @tags = DatabaseHelper.tags(session[:user_id])
    #GET	/photos	index	отображает список всех фото
  end
#  GET	/photos/new	new	возвращает форму HTML для создания нового фото
#  POST	/photos	create	создает новое фото
#GET	/photos/:id	show	отображает определенное фото
  def edit
    tag_id = params[:id]
    @tag = DatabaseHelper.get_tag(session[:user_id],tag_id)
  end

  def update
    tag = Tag.new()
    tag.id = params[:id]
    tag.name = params[:tag][:name]
    tag.user_id = session[:user_id]
    result = DatabaseHelper.edit_tag(tag)
    #if result
    #  session[:tags].each_pair do |tag_id, tag_name|
    #    session[:tags][tag_id] = tag.name if tag_id == tag.id.to_i
    #  end
    #end
    redirect_to action: :index, controller: :resources
  end


  def destroy
    result = DatabaseHelper.delete_tag(session[:user_id], params[:id])
    #session[:tags] = session[:tags].delete(params[:id]) if result
    redirect_to :back
    #DELETE	/photos/:id	destroy	удаляет определенное фото
  end
end