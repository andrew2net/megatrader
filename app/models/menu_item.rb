class MenuItem < ActiveRecord::Base
  belongs_to :page
  validates :title, :type_id, presence: true
  translates :title

  URLS = {ru: {news: 'poleznaja-informacija', articles: 'novosti'}, en: {news: 'poleznaja-informacija-en', articles: 'novosti-en'}}

  def url
    case self.type_id
      when 1
        Page.find(self.page_id).url
      when 2
        URLS[I18n.locale][:articles]
      when 3
        URLS[I18n.locale][:news]
    end
  end

  def self.menu_items
    where('weight > 0').reorder(:weight)
  end
end
