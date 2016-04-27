class CreateToolGroups < ActiveRecord::Migration
  def change
    create_table :tool_groups do |t|
      t.string :name
      t.integer :position, limit: 4

      t.timestamps null: false
    end
  end
end
