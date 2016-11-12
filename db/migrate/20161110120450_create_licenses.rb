class CreateLicenses < ActiveRecord::Migration
  def change
    create_table :licenses do |t|
      t.text :text
      t.string :email
      t.boolean :blocked

      t.timestamps null: false
    end
  end
end
