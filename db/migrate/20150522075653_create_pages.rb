class CreatePages < ActiveRecord::Migration
  def up
    create_table :pages do |t|
      t.string :title
      t.string :url
      t.text :text
      t.integer :weight

      t.timestamps null: false
    end
    Page.create_translation_table! title: :string, url: :string, text: :text
  end

  def down
    drop_table :pages
    Page.drop_translation_table!
  end
end
