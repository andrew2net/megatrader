class Admin::PagesController < ApplicationController
  load_and_authorize_resource param_method: :page_params
  layout 'admin'
  I18n.locale = :ru
  add_breadcrumb '', :admin_root_path, options: {class: 'glyphicon glyphicon-home'}
  add_breadcrumb Page.model_name.human, :admin_pages_path

  def index
    @pages_grid = initialize_grid(Page.order(:created_at).with_translations(:ru))
  end

  def new
    add_breadcrumb t :new, :new_admin_pages_path
    @page = Page.new
    session[:return_to] ||= request.referer
  end

  def edit
    add_breadcrumb t :edit, edit_admin_page_path: params[:id]
    @page = Page.with_translations(:ru).find params[:id]
    session[:return_to] ||= request.referer
  end

  def update
    @page = Page.find params[:id]
    @page.attributes = page_params
    @page.attributes = locale_attrs :ru
    @page.attributes = locale_attrs :en

    if @page.save
      Dir.glob(Rails.root.join('public', 'images', 'pages', "#{@page.id}_*")).each { |file|
        rgx = Regexp.new(File.join 'images', 'pages', File.basename(file));
        I18n.locale = :ru
        ru_text= @page.text
        I18n.locale = :en
        en_text = @page.text
        File.delete file unless rgx === ru_text or rgx === en_text
      }
      gflash :success
      redirect_to session.delete(:return_to) || admin_pages_path
    else
      gflash :error
      render 'edit'
    end
  end

  def create
    @page = Page.new(page_params)
    @page.attributes = locale_attrs :ru
    @page.attributes = locale_attrs :en
    if @page.save
      file_name_replace = Regexp.new "(/images/pages/)(new_#{current_user.id})"
      Dir.glob Rails.root.join('public', 'images', 'pages', 'new_*') do |file|
        new_file_name = file.sub file_name_replace, '\1' << @page.id.to_s
        File.rename(file, new_file_name)
      end

      # file_name_replace = Regexp.new "(/images/pages/)(new_#{current_user.id})"
      @page.text.gsub! file_name_replace, '\1' << @page.id.to_s
      @page.save
      gflash :success
      redirect_to session.delete(:return_to) || admin_pages_path
    else
      gflash :error
      render 'new'
    end
  end

  def destroy
    @page = Page.find params[:id]
    @page.destroy
    Dir.glob(Rails.root.join('public', 'images', 'pages', "#{@page.id}_*")).each { |file| File.delete file }
    gflash :success
    redirect_to admin_pages_path
  end

  private
  def page_params
    params.require(:page).permit(:title, :url, :type_id, :text)
  end

  def locale_attrs locale
    Hash[params[:page][locale]].merge({locale: locale})
  end
end
