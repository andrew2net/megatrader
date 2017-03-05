class Admin::WebinarsController < ApplicationController
  load_and_authorize_resource
  layout 'admin'
  I18n.locale = :ru
  add_breadcrumb '', :admin_root_path, options: {class: 'glyphicon glyphicon-home'}
  add_breadcrumb Webinar.model_name.human

  def index
    respond_to do |f|
      f.html
      f.json do
        render json: UserWebinar.joins(:user, webinar: :translations)
          .where("webinar_translations.locale='ru'").select(
          %{user_webinars.id, users.email, webinar_translations.name,
          users.locale, user_webinars.created_at}
        )
      end
    end
  end
end
