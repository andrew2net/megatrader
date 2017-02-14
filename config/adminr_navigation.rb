SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |primary|
    primary.item :logout, {icon: 'glyphicon glyphicon-log-out', title: I18n.t(:sign_out)}, admin_session_destroy_path(return_path: request.fullpath), method: :delete
    primary.dom_class = 'navbar-right'
  end
end
