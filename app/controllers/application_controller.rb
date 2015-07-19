class ApplicationController < ActionController::Base
  before_action :set_locale
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_admin_session, :current_user
  before_action :authenticate

  def default_url_options (options={})
    {locale: I18n.locale}.merge options
  end

  def set_locale
    if /^\/(?:admin|tinymce_assets)/.match(request.fullpath)
      I18n.locale = :ru
      return
    elsif params[:locale]
      l=params[:locale]
    elsif cookies[:locale] && I18n.available_locales.include?(cookies[:locale].to_sym)
      l = cookies[:locale].to_sym
    else
      l = http_accept_language.preferred_language_from I18n.available_locales
    end
    cookies.permanent[:locale] = l
    redirect_to "/#{l}#{request.fullpath}" unless params[:locale] or /^\/admins/.match(request.fullpath)
    I18n.locale = l
  end

  rescue_from CanCan::AccessDenied do |exception|
    gflash :now, error: exception.message
    render 'admin/forbidden'
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_admin_session && current_admin_session.admin
  end

  private
  def authenticate
    unless current_user
      @return_path = params[:return_path] || request.fullpath
      @admin_session = AdminSession.new
      render 'admin/login', layout: false
    end
  end

  def current_admin_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = AdminSession.find
  end

end
