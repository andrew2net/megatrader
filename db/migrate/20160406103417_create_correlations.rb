class CreateCorrelations < ActiveRecord::Migration
  def change
    create_table :correlations do |t|
      t.integer :row_tool_symbol_id, foreing_key: true
      t.integer :col_tool_symbol_id, index: true, foreing_key: true
      t.decimal :value, precision: 3, scale: 2

      t.timestamps null: false
    end
    add_index :correlations, [:row_tool_symbol_id, :col_tool_symbol_id], unique: true
  end
end
