FactoryGirl.define do
  factory :setting do
    name "notify_email"
    value "admin@abcd.nn"
  end

  factory :setting_salt, class: Setting do
    name 'Salt'
    value '1234'
  end
end
