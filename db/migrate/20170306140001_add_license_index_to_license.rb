class AddLicenseIndexToLicense < ActiveRecord::Migration
  def change
    add_index :licenses, :text, unique: true
  end
end
