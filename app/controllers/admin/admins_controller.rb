class Admin::AdminsController < ApplicationController
  load_and_authorize_resource param_method: :admin_params
  layout 'admin'
  I18n.locale = :ru
  add_breadcrumb '', :admin_root_path, options: {class: 'glyphicon glyphicon-home'}
  add_breadcrumb Admin.model_name.human, :admin_admins_path

  def index
    @admins_grid = initialize_grid(Admin)
  end

  def new
    add_breadcrumb t :new, :new_admin_admin_path
    @admin = Admin.new
    session[:return_to] ||= request.referer
  end

  def edit
    add_breadcrumb t :edit, edit_admin_admin_path: params[:id]
    @admin = Admin.find(params[:id])
    session[:return_to] ||= request.referer
  end

  def update
    @admin = Admin.find(params[:id])

    if admin_params[:password].empty?
      attributes = admin_params.slice(:first_name, :last_name, :email)
      result = @admin.update_attributes(attributes)
    else
      result = @admin.update(admin_params)
    end

    if result
      @admin.role_ids = params[:admin][:role_ids]
      gflash success: true
      redirect_to session.delete(:return_to) || admin_admins_path
    else
      gflash :error
      render 'edit'
    end
  end

  def create
    @admin = Admin.new(admin_params)
    if @admin.save
      @admin.role_ids = params[:admin][:role_ids]
      gflash :success
      redirect_to session.delete(:return_to) || admin_admins_path
    else
      gflash :error
      render 'new'
    end
  end

  def destroy
    @admin = Admin.find(params[:id])
    @admin.destroy
    gflash :success
    redirect_to admin_admins_path
  end

  private
  def admin_params
    params.require(:admin).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end
end
