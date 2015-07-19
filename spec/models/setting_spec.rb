require 'rails_helper'

RSpec.describe Setting, type: :model do
  it 'can save option notify_email' do
    create :notify_email_setting
    setting = Setting.find_by name: 'notify_email'
    expect(setting).to_not be_nil
  end
end
