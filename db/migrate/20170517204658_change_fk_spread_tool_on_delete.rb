class ChangeFkSpreadToolOnDelete < ActiveRecord::Migration
  def change
    remove_foreign_key :spreads, :tool_symbols
    add_foreign_key :spreads, :tool_symbols, on_delete: :cascade
  end
end
