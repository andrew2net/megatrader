FactoryGirl.define do
  factory :admin_role, class: :role do
    name "admin"
  end

  factory :editor_role, class: :role do
    name "editor"
  end
end
