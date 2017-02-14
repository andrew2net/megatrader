class CreateDownloads < ActiveRecord::Migration
  def change
    create_table :downloads do |t|
      t.references :user, null: false, foreign_key: {on_delete: :cascade}
      t.uuid :token, null: false, index: true

      t.timestamps null: false
    end
  end
end
