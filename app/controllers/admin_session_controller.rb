class AdminSessionController < ApplicationController
  skip_before_action :authenticate

  def create
    @admin_session = AdminSession.new(admin_params)
    if @admin_session.save
      flash[:notice] = t :sign_in_success
      gflash :now, notice: (t :sign_in_success)
      redirect_to params[:return_path]
    else
      flash[:notice] = t :sign_in_false
      gflash :now, error: (t :sign_in_false)
      @return_path = params[:return_path] || request.fullpath
      render 'admin/login', layout: false
    end
  end

  def destroy
    current_admin_session.destroy
    gflash :now, notice: (t :sign_out_success)
    redirect_to params[:return_path]
  end

  protected
  def admin_params
    params.require(:admin_session).permit :email, :password, :remember_me
  end
end
