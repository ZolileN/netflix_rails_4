class User < ActiveRecord::Base
  validates :email, presence: true, uniqueness: true
  validates :full_name, presence: true

  has_secure_password

  before_validation { self.email = email.downcase }
end
