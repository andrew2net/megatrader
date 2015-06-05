class Admin::SettingsController < ApplicationController
  load_and_authorize_resource param_method: :user_params
  layout 'admin'
  I18n.locale = :ru
  add_breadcrumb '', :admin_root_path, options: {class: 'glyphicon glyphicon-home'}
  add_breadcrumb Setting.model_name.human, :edit_admin_setting_path

  def edit
    @settings = Setting.all
  end

  def update
    params[:options].each { |key, option|
      setting = Setting.find key
      setting.value = option[:value]
      setting.save
    }
    gflash :now, success: true
    redirect_to edit_admin_setting_path
  end

  private
  def setting_params
    params.require(:user).permit(:name, :value)
  end
end
