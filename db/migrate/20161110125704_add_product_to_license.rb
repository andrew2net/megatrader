class AddProductToLicense < ActiveRecord::Migration
  def change
    add_reference :licenses, :product, index: true, foreign_key: true
  end
end
