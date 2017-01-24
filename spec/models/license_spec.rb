require 'rails_helper'

RSpec.describe License, type: :model do
  it 'delete with logs' do
    license = create :license_with_logs
    license.destroy
    expect(License.count).to eq(0)
    expect(LicenseLog.count).to eq(0)
  end
end
