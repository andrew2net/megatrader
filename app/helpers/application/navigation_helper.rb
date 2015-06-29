module Application
  module NavigationHelper
    def main_menu_items
      proc do |primary|
        primary.dom_class = 'nav navbar-nav'
        MenuItem.menu_items.all.each do |item|
          # url = "/#{I18n.locale}/#{item.url}"
          primary.item item.url, item.title, item.url, highlights_on: /^\/#{item.url.sub(/^\/(en|ru)\/{0,1}/, '')}(\?|$)/
        end
      end
    end
  end
end