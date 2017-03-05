class UserWebinar < ActiveRecord::Base
  belongs_to :user
  belongs_to :webinar
end
