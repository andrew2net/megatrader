module Admin::MenuItemsHelper
  def menu_parents
    MenuItem.with_translations(:ru).select(:id, :title).where(type_id: 4)
  end
end
