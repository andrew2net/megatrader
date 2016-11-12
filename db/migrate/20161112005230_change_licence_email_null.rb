class ChangeLicenceEmailNull < ActiveRecord::Migration
  def change
    change_column_null :licenses, :email, false
  end
end
