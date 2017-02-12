class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email, null: false, index: true
      t.boolean :send_news, null: false, index: true, default: true
      t.string :locale, null: false, default: :en

      t.timestamps null: false
    end
  end
end
