class CreateLicenseLogs < ActiveRecord::Migration
  def change
    create_table :license_logs do |t|
      t.inet :ip, null: false
      t.references :license, index: true, null: false

      t.timestamp :created_at, null: false
    end
    add_foreign_key :license_logs, :licenses
  end
end
