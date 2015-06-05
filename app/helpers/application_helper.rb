module ApplicationHelper
  def my_gflash
    session[:gflash].symbolize_keys! unless session[:gflash].nil?
    gflash
  end
end
