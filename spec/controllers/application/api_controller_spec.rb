require 'rails_helper'

RSpec.describe Application::ApiController, type: :controller do
  describe 'POST request' do
    a = [[[101, 103, 105, 107, 106, 104, 102], [115, 117, 119, 121, 120, 118, 116], [129, 131, 133, 135, 134, 132, 130], [122, 124, 126, 128, 127, 125, 123], [108, 110, 112, 114, 113, 111, 109]], [[101, 103, 105, 107, 106, 104, 102], [115, 117, 119, 121, 120, 118, 116], [129, 131, 133, 135, 134, 132, 130], [122, 124, 126, 128, 127, 125, 123], [108, 110, 112, 114, 113, 111, 109]], [[101, 103, 105, 107, 106, 104, 102], [115, 117, 119, 121, 120, 118, 116], [129, 131, 133, 135, 134, 132, 130], [122, 124, 126, 128, 127, 125, 123], [108, 110, 112, 114, 113, 111, 109]], [[101, 103, 105, 107, 106, 104, 102], [115, 117, 119, 121, 120, 118, 116], [129, 131, 133, 135, 134, 132, 130], [122, 124, 126, 128, 127, 125, 123], [108, 110, 112, 114, 113, 111, 109]]]
    b = [[[101,102,103,104,105,106,107],[108,109,110,111,112,113,114],[115,116,117,118,119,120,121],[122,123,124,125,126,127,128],[129,130,131,132,133,134,135]],[[101,102,103,104,105,106,107],[108,109,110,111,112,113,114],[115,116,117,118,119,120,121],[122,123,124,125,126,127,128],[129,130,131,132,133,134,135]],[[101,102,103,104,105,106,107],[108,109,110,111,112,113,114],[115,116,117,118,119,120,121],[122,123,124,125,126,127,128],[129,130,131,132,133,134,135]],[[101,102,103,104,105,106,107],[108,109,110,111,112,113,114],[115,116,117,118,119,120,121],[122,123,124,125,126,127,128],[129,130,131,132,133,134,135]]]
    b.map!{|a1| a1.map{|a2| a2.map(&:to_s)}}

    it 'respond successfully with valid license' do
      create :setting_salt
      license = create :license, key: 'da4c1932-8e99-c5fb-01b0-a5b1585fa8cc'
      post :license, a: a, l: license.text, k: license.key
      expect(response).to have_http_status 200
      expect(response.body).to include_json(b: b)
      resp = JSON.parse response.body
      post :license, a: a, l: license.text, k: resp['k']
      expect(response).to have_http_status 200
      expect(LicenseLog.count).to eq 2
    end

    it 'respond not found with blocked license' do
      create :setting_salt
      license = create :license, blocked: true
      post :license, a: a, l: license.text, k: ''
      expect(response).to have_http_status 404
      expect(response.body).to include_json(m: 'License not found')
    end

    it 'respond bad key with invalid key' do
      create :setting_salt
      license = create :license, key: 'da4c1932-8e99-c5fb-01b0-a5b1585fa8cc'
      post :license, a: a, l: license.text, k: ''
      expect(response).to have_http_status 404
      expect(response.body).to include_json(m: 'Bad key')
    end

    it 'response expired with expired license' do
      create :setting_salt
      license = create :license, key: 'da4c1932-8e99-c5fb-01b0-a5b1585fa8cc',
        date_end: (Date.today - 1.day)
      post :license, a: a, l: license.text,
        k: 'da4c1932-8e99-c5fb-01b0-a5b1585fa8cc'
      expect(response).to have_http_status 404
      expect(response.body).to include_json(m: 'License is expired')
    end
  end
end
