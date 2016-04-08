class CreateToolSymbols < ActiveRecord::Migration
  def change
    create_table :tool_symbols do |t|
      t.string :name, limit: 6

      t.timestamps null: false
    end
    add_index :tool_symbols, :name, unique: true
    reversible do |dir|
      dir.up do
        ToolSymbol.create name: 'AUDUSD'
        ToolSymbol.create name: 'EURUSD'
        ToolSymbol.create name: 'GBPUSD'
        ToolSymbol.create name: 'NZDUSD'
        ToolSymbol.create name: 'XAGUSD'
        ToolSymbol.create name: 'XAUUSD'
      end
    end
  end
end
