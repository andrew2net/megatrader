FactoryGirl.define do
  factory :admin do
    first_name "Andrew"
    last_name "K"
    email "admin@example.com"
    password '12345678'
    password_confirmation '12345678'
    after(:create) { |admin| admin.roles = [create(:admin_role)] }
  end

end
