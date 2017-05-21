class AddUserToLicense < ActiveRecord::Migration
  def change
    add_reference :licenses, :user, index: true, foreign_key: true

    reversible do |dir|
      dir.up do
        License.all.each do |l|
          user = User.find_or_create_by email: l.email
          l.update_attribute :user_id, user.id
        end
        change_column_null :licenses, :user_id, false
        remove_column :licenses, :email
      end
      dir.down do
        add_column :licenses, :email, :string, null: false
        License.all.each do |l|
          l.update_attribute :mail, l.user.email
        end
        remove_column :licenses, :user_id
      end
    end
  end
end
