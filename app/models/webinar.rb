class Webinar < ActiveRecord::Base
  has_many :user_webinars
  translates :name
end
