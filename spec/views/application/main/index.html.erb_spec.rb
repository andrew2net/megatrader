require 'rails_helper'

RSpec.describe "application/main/index.html.erb", type: :view do
  context 'when display the pages' do
    it 'display the home page' do
      page = build(:home_page)
      assign :page, page
      assign :text, page.text
      render
      expect(rendered).to match /Home page text/
    end
  end
end
