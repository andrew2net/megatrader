FactoryGirl.define do
  factory :admin do
    first_name "Andrew"
    last_name "K"
    email "admin@example.com"
    password '1234'
    password_confirmation '1234'
    after(:create) { |admin| admin.roles = [create(:admin_role)] }
  end

end
