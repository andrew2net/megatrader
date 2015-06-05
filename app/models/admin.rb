class Admin < ActiveRecord::Base
  has_and_belongs_to_many :roles
  validates :email, presence: true
  validates :password, :password_confirmation, presence: true, on: :create

  acts_as_authentic do |c|
    c.login_field = :email
  end
end
