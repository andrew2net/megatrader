require 'rails_helper'

RSpec.describe 'Routing to home', type: :routing do
  it 'routes /:locale to main#index' do
    expect(get: '/ru').to route_to(
      controller: 'application/main',
      action: 'index',
      locale: 'ru'
    )
  end
end
