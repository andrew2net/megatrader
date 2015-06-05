class AddTypeToPages < ActiveRecord::Migration
  def change
    rename_column :pages, :weight, 'type_id'
  end
end
