class AddFullNameToToolSymbol < ActiveRecord::Migration
  def change
    add_column :tool_symbols, :full_name, :string
    add_reference :tool_symbols, :tool_group, index: true, foreign_key: true
    reversible do |dir|
      dir.up do
        Spread.delete_all
        ToolSymbol.delete_all
        change_column :tool_symbols, :name, :string, limit: 10
        Admin::GetToolsWorker.perform_in 10.second
        Admin::GetCorrelationWorker.perform_in 30.second
        # Admin::GetSpreadWorker.perform_in 30.seconds
      end
    end
  end
end
