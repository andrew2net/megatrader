class Page < ActiveRecord::Base
  validates :title, presence: true, length: {maximum: 255}
  validates :url, uniqueness: true
  validates :type_id, numericality: {only_integer: true, allow_blank: true}
  translates :title, :url, :text, :keywords, :description

  TYPES = {menu: 4, page: 1, articles: 2, news: 3}

  def self.menu_items
    where('weight > 0').reorder(:weight)
  end

  def self.news
    where(type_id: 3).reorder(created_at: :desc)
  end

  def self.articles
    where(type_id: 2).where.not(url: '').reorder(created_at: :desc)
  end
end
