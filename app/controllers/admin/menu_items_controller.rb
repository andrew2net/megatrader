class Admin::MenuItemsController < ApplicationController
  load_and_authorize_resource param_method: :menu_params
  layout 'admin'
  I18n.locale = :ru
  add_breadcrumb '', :admin_root_path, options: {class: 'glyphicon glyphicon-home'}
  add_breadcrumb MenuItem.model_name.human, :admin_menu_items_path

  def index
    @menu_grid = initialize_grid MenuItem.with_translations(:ru)
  end

  def new
    add_breadcrumb t :new, :new_admin_menu_items_path
    @menu_item = MenuItem.new
    session[:return_to] ||= request.referer
  end

  def create
    @menu_item = MenuItem.new(menu_params)
    locale_attrs
    if @menu_item.save
      gflash :success
      redirect_to session.delete(:return_to) || admin_menu_items_path
    else
      gflash :error
      render 'new'
    end
  end

  def edit
    add_breadcrumb t :edit, :edit_admin_menu_items_path
    @menu_item = MenuItem.find params[:id]
    session[:return_to] ||= request.referer
  end

  def update
    @menu_item = MenuItem.find params[:id]
    @menu_item.attributes = menu_params
    locale_attrs
    if @menu_item.save
      gflash :success
      redirect_to session.delete(:return_to) || admin_menu_items_path
    else
      gflash :error
      render 'edit'
    end
  end

  def destroy
    MenuItem.find(params[:id]).destroy
    redirect_to admin_menu_items_path
  end

  private
  def menu_params
    params.require(:menu_item).permit(:title, :type_id, :page_id, :weight)
  end

  def locale_attrs
    @menu_item.attributes = Hash[params[:menu_item][:ru]].merge({locale: :ru})
    @menu_item.attributes = Hash[params[:menu_item][:en]].merge({locale: :en})
  end
end
