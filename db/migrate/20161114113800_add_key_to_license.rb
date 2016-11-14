class AddKeyToLicense < ActiveRecord::Migration
  def change
    add_column :licenses, :key, :uuid, index: true
  end
end
