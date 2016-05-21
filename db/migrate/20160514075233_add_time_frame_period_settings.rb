class AddTimeFramePeriodSettings < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up do
        TimeFrame.find_or_create_by name: 'm1'
        TimeFrame.find_or_create_by name: 'm5'
        TimeFrame.all.each do |t|
          Setting.find_or_create_by name: t.name + '_period'
        end
      end
      dir.down do
      end
    end
  end
end
