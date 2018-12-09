source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.1'
# Use postgresql as the database for Active Record
gem 'pg'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 3.2'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
# gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn', group: :production
gem "passenger", ">= 5.0.25", require: "phusion_passenger/rack_handler", group: :production

# Use Capistrano for deployment
group :development do
  # gem 'capistrano3-nginx', '~> 2.0'
  # gem 'capistrano'
  # gem 'capistrano-bundler'
  # gem 'capistrano-rails'
  # gem 'capistrano-rvm'
  # gem 'capistrano-sidekiq'
  gem 'mina'
  gem 'rails-erd'
end

# gem 'sprockets', '~> 2'
gem 'sprockets-rails'

gem 'rails-i18n', '~> 4.0.0'

gem 'authlogic'
gem 'bootstrap-sass', '~> 3.3.6'
gem 'breadcrumbs_on_rails', git: 'https://github.com/weppos/breadcrumbs_on_rails.git'
gem 'cancancan'
gem 'gritter'
gem 'http_accept_language'
gem 'routing-filter'
gem 'simple-navigation'
gem 'simple_form'
gem 'simple_navigation_renderers'
gem 'tinymce-rails'
gem 'tinymce-rails-langs'
gem 'wice_grid'

# gem 'tinymce-rails-imageupload'
gem 'angular_rails_csrf'
gem 'email_validator'
gem 'faraday'
gem 'ffi'
gem 'globalize', '~> 5.0.0'
gem 'jquery-ui-rails'
gem 'sidekiq'
gem 'sidekiq-scheduler', '~> 2.0'
gem 'slim'
gem 'validates_email_format_of'
# Foundation for email
gem 'inky-rb', require: 'inky'
# Stylesheet inlining for email
gem 'premailer-rails'

group :development, :test do
  gem 'pry-byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the
  # background. Read more: https://github.com/rails/spring
  gem 'spring'

  # gem 'debugger-xml'
  # gem 'debugger'
  # gem 'ruby-debug-ide19'

  gem 'factory_girl_rails'
  gem 'rspec-json_expectations'
  gem 'rspec-rails'
end

group :test do
  gem 'capybara'
  gem 'capybara-webkit'
  gem 'database_cleaner'
  gem 'poltergeist'
  # gem 'selenium-webdriver'
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
end
