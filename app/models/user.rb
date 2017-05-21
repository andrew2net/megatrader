class User < ActiveRecord::Base
  has_one :download, inverse_of: :user
  has_many :user_webinars
  has_many :messages, inverse_of: :user
  has_many :licenses, inverse_of: :user
  validates :email, presence: true
  validates_email_format_of :email

  def update_download
    token = Digest::MD5.hexdigest email + DateTime.now.to_s
    if download
      download.update token: token
    else
      create_download token: token
    end
  end
end
