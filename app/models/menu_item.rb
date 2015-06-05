class MenuItem < ActiveRecord::Base
  validates :title, :type_id, presence: true
  belongs_to :page
  translates :title

  URLS = {ru: {news: 'poleznaja-informacija', articles: 'novosti'}, en: {news: 'poleznaja-informacija-en', articles: 'novosti-en'}}

end
