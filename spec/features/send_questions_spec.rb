require 'rails_helper'

RSpec.feature "SendQuestions", type: :feature, js: true do
  scenario 'User send a question' do
    create :setting
    create :home_page
    visit '/ru'
    within 'form#question-form' do
      fill_in 'name', with: 'John'
      fill_in 'email', with: 'android.2net@gmail.com'
      fill_in 'question', with: 'My question'
      click_button I18n.t :ask
    end
    expect(page).to have_text 'Сообщение отправлено.'
  end
end
