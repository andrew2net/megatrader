class RemoveToolsAaplEbayHpqKoSbuxV < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up do
        tools_to_remove = ['AAPL', 'EBAY', 'HPQ', 'KO', 'SBUX', 'V']
        tool_ids = ToolSymbol.where(name: tools_to_remove).ids
        Spread.delete_all(tool_symbol_id: tool_ids)
        ToolSymbol.delete_all name: tools_to_remove
      end
    end
  end
end
