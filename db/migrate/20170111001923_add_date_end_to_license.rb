class AddDateEndToLicense < ActiveRecord::Migration
  def change
    add_column :licenses, :date_end, :date
  end
end
