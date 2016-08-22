class ChangePairWeghtPrecision < ActiveRecord::Migration
  def change
    change_column :pairs, :weight_1, :decimal, precision: 8
    change_column :pairs, :weight_2, :decimal, precision: 8
  end
end
