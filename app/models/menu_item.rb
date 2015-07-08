class MenuItem < ActiveRecord::Base
  belongs_to :page
  validates :title, :type_id, presence: true
  translates :title

  URLS = {
      news: {ru: {method: :news_ru_path, params: {}}, en: {method: :news_en_path, params: {}}},
      articles: {ru: {method: :articles_ru_path, params: {}}, en: {method: :articles_en_path, params: {}}}
  }

  def url
    case self.type_id
      when 1
        Rails.application.routes.url_helpers.page_path(url: Page.find(self.page_id).url)
      when 2
        Rails.application.routes.url_helpers.send(URLS[:articles][I18n.locale][:method], locale: I18n.locale)
      when 3
        Rails.application.routes.url_helpers.send(URLS[:news][I18n.locale][:method])
    end
  end

  def self.menu_items
    where('weight > 0').reorder(:weight)
  end
end
