class AddSettingRloadSpred < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up do
        Setting.create name: 'reload_spread'
      end
      dir.down do
        Setting.where(name: 'reload_spread').delete_all
      end
    end
  end
end
