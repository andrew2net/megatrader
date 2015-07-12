class AddMetatagsToPages < ActiveRecord::Migration
  def up
    Page.add_translation_fields! keywords: :string, description: :string
  end

  def down
    remove_column :page_translations, :keywords
    remove_column :page_translations, :description
  end
end
