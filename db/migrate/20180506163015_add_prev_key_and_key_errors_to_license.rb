class AddPrevKeyAndKeyErrorsToLicense < ActiveRecord::Migration
  def change
    add_column :licenses, :prev_key, :uuid
    add_column :licenses, :key_errors, :integer

    remove_index :licenses, :text
    add_index :licenses, %i[text blocked]
  end
end
