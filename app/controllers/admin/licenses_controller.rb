class Admin::LicensesController < ApplicationController
  load_and_authorize_resource param_method: :admin_params
  layout 'admin'
  I18n.locale = :ru
  add_breadcrumb '', :admin_root_path, options: {class: 'glyphicon glyphicon-home'}
  add_breadcrumb I18n.t(:licenses)

  def index
    render json: License.select(:id, :email, :product_id, :text, :blocked)
  end

  def create
    render json: License.create(license_params),
      only: [:id, :email, :product_id, :text, :blocked]
  end

  def update
    render json: License.update(params[:id], license_params),
      only: [:id, :email, :product_id, :text, :blocked]
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

  private
  def license_params
    params.require(:license).permit(:email, :text, :product_id, :blocked)
  end
end
