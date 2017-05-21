class Admin::LicensesController < ApplicationController
  load_and_authorize_resource param_method: :admin_params
  layout 'admin'
  I18n.locale = :ru
  add_breadcrumb '', :admin_root_path, options: {class: 'glyphicon glyphicon-home'}
  add_breadcrumb I18n.t(:licenses)

  def index
    @licenses = License.all
    respond_to do |format|
      format.json
    end
  end

  def create
    user = User.find_or_create_by email: params[:email]
    license = License.new license_params
    license.user = user
    license.save if user.persisted?
    respond_to do |format|
      format.json {render partial: 'form', locals: { license: license }}
    end
  end

  def update
    user = User.find_or_create_by email: params[:email]
    license = License.find params[:id]
    license.attributes = license_params
    license.user = user
    license.save if user.persisted?
    respond_to do |format|
      format.json { render partial: 'form', locals: { license: license}}
    end
  end

  def destroy
    License.destroy params[:id]
    head :ok
  end

  def view
  end

  def products
    render json: Product.select('id, name')
  end

  def logs
    render json: LicenseLog.select(:id, :ip, :created_at)
      .where(license_id: params[:license_id])
      .map{|l| {id: l.id, ip: l.ip.to_s, created_at: l.created_at}}
  end

  private
  def license_params
    params.require(:license).permit(:text, :product_id, :blocked, :key,
                                   :date_end)
  end
end
