class Page < ActiveRecord::Base
  validates :title, :url, presence: true, length: {maximum: 255}
  validates :type_id, numericality: {only_integer: true, allow_blank: true}
  translates :title, :url, :text

  TYPES = {page: 1, article: 2, news: 3}

  def self.menu_items
    where('weight > 0').reorder(:weight)
  end
end
