class CreateMenuItems < ActiveRecord::Migration
  def up
    create_table :menu_items do |t|
      t.integer :type_id, null: false
      t.integer :page_id
      t.integer :weight

      t.timestamps null: false
    end
    MenuItem.create_translation_table! title: {type: :string, null: false}
  end

  def down
    drop_table :menu_items
    MenuItem.drop_translation_table!
  end
end
