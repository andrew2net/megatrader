class CreateUserWebinars < ActiveRecord::Migration
  def change
    create_table :user_webinars do |t|
      t.references :user, null: false, foreign_key: true
      t.references :webinar, null: false, foreign_key: true

      t.timestamps null: false
    end
  end
end
