class AddTimeFrameToCorrelation < ActiveRecord::Migration
  def change
    Correlation.delete_all
    add_reference :correlations, :time_frame, index: true
    add_foreign_key :correlations, :time_frames
    remove_index :correlations, [:row_tool_symbol_id, :col_tool_symbol_id]
    add_index :correlations, [:row_tool_symbol_id]
    Admin::GetCorrelationWorker.perform_in 30.seconds
  end
end
