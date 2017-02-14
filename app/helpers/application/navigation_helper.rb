module Application
  module NavigationHelper
    def main_menu_items
      proc do |primary|
        # primary.dom_class = 'nav navbar-nav'
        MenuItem.menu_items.with_translations(I18n.locale).includes(:page).where(parent: nil).each do |item|
          # url = "/#{I18n.locale}/#{item.url}"
          if item.type_id == 4
            primary.item item.id, {icon: '', text: item.title} do |subnav|
              # subnav.dom_class = 'dropdown-menu'
              item.subitems.each do |subitem|
                subnav.item subitem.id, subitem.title, subitem.url, link: { target: '_self' }, highlights_on: /^\/#{subitem.url.sub(/^\/(en|ru)\/{0,1}/, '')}(\?|\/|$)/
              end
            end
          else
            primary.item item.id, item.title, item.url, link: { target: '_self' }, highlights_on: /^\/#{item.url.sub(/^\/(en|ru)\/{0,1}/, '')}(\?|\/|$)/
          end
        end
      end
    end
  end
end
