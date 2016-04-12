class CreateTimeFrames < ActiveRecord::Migration
  def change
    create_table :time_frames do |t|
      t.string :name, limit: 3

      t.timestamps null: false
    end
    reversible do |dir|
      dir.up do
        TimeFrame.create name: 'm15'
        TimeFrame.create name: 'm30'
        TimeFrame.create name: 'h1'
        TimeFrame.create name: 'h4'
        TimeFrame.create name: 'd1'
      end
    end
  end
end
