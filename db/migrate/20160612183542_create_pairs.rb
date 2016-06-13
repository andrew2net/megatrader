class CreatePairs < ActiveRecord::Migration
  def change
    create_table :pairs do |t|
      t.references :time_frame, index: true
      t.integer :tool_symbol_1_id, index: true
      t.integer :tool_symbol_2_id, index: true
      t.decimal :weight_1, precision: 7, scale: 2
      t.decimal :weight_2, precision: 7, scale: 2
      t.decimal :fitness, precision: 3

      t.timestamps null: false
    end
    add_foreign_key :pairs, :time_frames
    add_foreign_key :pairs, :tool_symbols, column: :tool_symbol_1_id
    add_foreign_key :pairs, :tool_symbols, column: :tool_symbol_2_id
    reversible do |dir|
      dir.up do
        execute <<-SQL
        CREATE UNIQUE INDEX pair_unique_idx ON pairs
          (time_frame_id, LEAST(tool_symbol_1_id, tool_symbol_2_id),
            GREATEST(tool_symbol_1_id, tool_symbol_2_id));

        ALTER TABLE pairs ADD CONSTRAINT
          pair_no_self_loop_chk
            CHECK(tool_symbol_1_id <> tool_symbol_2_id);
        SQL
        # Admin::GetCorrelationWorker.perform_in 30.second
      end
      dir.down do
        execute <<-SQL
        DROP INDEX pair_unique_idx;
        ALTER TABLE pairs DROP CONSTRAINT pair_no_self_loop_chk;
        SQL
      end
    end
  end
end
