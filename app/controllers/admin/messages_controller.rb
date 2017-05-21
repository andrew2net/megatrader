class Admin::MessagesController < ApplicationController
  load_and_authorize_resource param_method: :admin_params
  layout 'admin'
  I18n.locale = :ru
  add_breadcrumb '', :admin_root_path, options: {class: 'glyphicon glyphicon-home'}
  add_breadcrumb Message.model_name.human #I18n.t :messages

  def index
    respond_to do |f|
      f.html
      f.json { @messages = Message.joins(:user) }
    end
  end
end
