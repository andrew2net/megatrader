class UsersController < ApplicationController
  load_and_authorize_resource param_method: :admin_params
  layout 'admin'
  I18n.locale = :ru
  add_breadcrumb '', :admin_root_path, options: {class: 'glyphicon glyphicon-home'}
  add_breadcrumb I18n.t :users

  def index
    response_for do |format|
      format.json
    end
  end
end
