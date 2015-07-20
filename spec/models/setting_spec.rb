require 'rails_helper'

RSpec.describe Setting, type: :model do
  it 'can save settings' do
    create :setting
    setting = Setting.find_by name: 'notify_email'
    expect(setting).to_not be_nil
  end
end
