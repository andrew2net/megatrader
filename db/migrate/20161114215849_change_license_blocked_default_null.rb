class ChangeLicenseBlockedDefaultNull < ActiveRecord::Migration
  def change
    License.where(blocked: nil).update_all blocked: false
    change_column_default :licenses, :blocked, false
    change_column_null :licenses, :blocked, false
  end
end
