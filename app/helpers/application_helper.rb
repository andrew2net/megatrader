module ApplicationHelper
  def my_gflash
    session[:gflash].symbolize_keys! unless session[:gflash].nil?
    gflash
  end

  def full_title(page_title='')
    base_title = t :title_suff
    if page_title.empty?
      base_title
    else
      page_title + ' | ' + base_title
    end
  end
end
