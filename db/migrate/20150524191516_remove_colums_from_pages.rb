class RemoveColumsFromPages < ActiveRecord::Migration
  def change
    remove_column :pages, :url, :string
    remove_column :pages, :title, :string
    remove_column :pages, :text, :string
  end
end
