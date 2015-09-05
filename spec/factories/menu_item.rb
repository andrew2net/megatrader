FactoryGirl.define do
  factory :menu_item, :class => 'MenuItem' do
    type_id 1
    association :page, factory: :home_page
    weight 1
    title 'Home page'
    after(:build) do |menu_item, evaluation|
      I18n.available_locales.each do |locale|
        menu_item.attributes = evaluation.attributes.merge({locale: locale})
      end
    end
  end
end
