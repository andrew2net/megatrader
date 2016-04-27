class AddPairIdxSelfConstrToCorrelation < ActiveRecord::Migration
  def change

    reversible do |dir|
      dir.up do
        Correlation.delete_all
        execute <<-SQL
        CREATE UNIQUE INDEX correlation_pair_unique_idx ON correlations
          (time_frame_id, LEAST(row_tool_symbol_id, col_tool_symbol_id),
            GREATEST(row_tool_symbol_id, col_tool_symbol_id));

        ALTER TABLE correlations ADD CONSTRAINT
          correlation_no_self_loop_chk
            CHECK(row_tool_symbol_id <> col_tool_symbol_id);
        SQL
        Admin::GetCorrelationWorker.perform_in 30.second
      end
      dir.down do
        execute <<-SQL
        DROP INDEX correlation_pair_unique_idx;
        ALTER TABLE correlations DROP CONSTRAINT correlation_no_self_loop_chk;
        SQL
      end
    end
  end
end
