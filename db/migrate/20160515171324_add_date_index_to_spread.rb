class AddDateIndexToSpread < ActiveRecord::Migration
  def change
    add_index :spreads, [:date_time, :time_frame_id, :tool_symbol_id], unique: true
    reversible do |dir|
      dir.up do
        Admin::GetSpreadWorker.perform_in 30.seconds
      end
    end
  end
end
