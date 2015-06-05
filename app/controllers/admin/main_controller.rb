class Admin::MainController < ApplicationController
  load_and_authorize_resource class: false
  layout 'admin'
  add_breadcrumb '', '#', options: {class: 'glyphicon glyphicon-home'}

  def index

  end
end
