class CreateSpreads < ActiveRecord::Migration
  def change
    create_table :spreads do |t|
      t.references :tool_symbol, index: true
      t.references :time_frame, index: true
      t.float :value
      t.datetime :date_time
    end
    add_foreign_key :spreads, :tool_symbols
    add_foreign_key :spreads, :time_frames
  end
end
