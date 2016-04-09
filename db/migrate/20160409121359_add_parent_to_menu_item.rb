class AddParentToMenuItem < ActiveRecord::Migration
  def change
    add_column :menu_items, :parent, :integer
    add_index :menu_items, :parent
  end
end
