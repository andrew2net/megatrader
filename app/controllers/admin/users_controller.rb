class Admin::UsersController < ApplicationController
  load_and_authorize_resource param_method: :admin_params
  layout 'admin'
  I18n.locale = :ru
  add_breadcrumb '', :admin_root_path, options: {class: 'glyphicon glyphicon-home'}
  add_breadcrumb I18n.t :users

  def index
    respond_to do |format|
      format.html
      format.json do
        render json: User.all,
        only: [:id, :email, :locale, :send_news]
      end
    end
  end
end
