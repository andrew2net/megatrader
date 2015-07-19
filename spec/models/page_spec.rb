require 'rails_helper'

RSpec.describe Page, type: :model do
  it 'is valid with a title, text, keywords and description' do
    page = build :home_page, id: 1
    expect(page).to be_valid
  end

  it 'is invalid without a title' do
    page = build :home_page, title: nil
    page.valid?
    expect(page.errors[:title]).to include I18n.t 'activerecord.errors.messages.blank'
  end

  it 'is invalid with a not unique url' do
    create :home_page
    page = build :home_page
    page.valid?
    expect(page.errors[:url]).to include I18n.t 'activerecord.errors.models.page.attributes.url.taken'
  end
end
