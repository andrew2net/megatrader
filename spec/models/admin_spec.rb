require 'rails_helper'

RSpec.describe Admin, type: :model do
  it 'is valid with a first_name, last_name, email, password and password confirmation' do
    admin = build :admin
    expect(admin).to be_valid
  end

  it 'is invalid without an email' do
    admin = build :admin, email: nil
    admin.valid?
    expect(admin.errors[:email]).to include I18n.t 'activerecord.errors.messages.blank'
  end

  it 'is invalid with a not unique email' do
    create :admin
    admin = build :admin
    admin.valid?
    expect(admin.errors[:email]).to include I18n.t 'activerecord.errors.models.admin.attributes.email.taken'
  end

  it 'is invalid without password' do
    admin = build :admin, password: nil
    admin.valid?
    expect(admin.errors[:password]).to include I18n.t 'activerecord.errors.messages.blank'
  end

  it 'is invalid without password confirmation' do
    admin = build :admin, password_confirmation: '1111'
    admin.valid?
    expect(admin.errors[:password_confirmation]).to include I18n.t 'activerecord.errors.messages.confirmation'
  end

  it 'is invalid when password less then 4 characters' do
    admin = build :admin, password: '1'
    admin.valid?
    expect(admin.errors[:password]).to include I18n.t 'activerecord.errors.messages.too_short', count: 4
  end
end
