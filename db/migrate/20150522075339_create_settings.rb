class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.string :name
      t.string :value

      t.timestamps null: false
    end
    Setting.create(name: 'notify_email')
  end
end
