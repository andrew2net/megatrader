class License < ActiveRecord::Base
  has_many :license_logs
  belongs_to :product
end
