require 'rails_helper'

RSpec.describe Role, type: :model do
  it 'can save role' do
    create :admin_role, id: 1
    role = Role.find 1
    expect(role).not_to be_nil
  end
end
