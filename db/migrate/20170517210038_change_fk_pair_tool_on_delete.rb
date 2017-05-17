class ChangeFkPairToolOnDelete < ActiveRecord::Migration
  def change
    remove_foreign_key :pairs, column: :tool_symbol_1_id
    remove_foreign_key :pairs, column: :tool_symbol_2_id
    add_foreign_key :pairs, :tool_symbols, column: :tool_symbol_1_id, on_delete: :cascade
    add_foreign_key :pairs, :tool_symbols, column: :tool_symbol_2_id, on_delete: :cascade
  end
end
