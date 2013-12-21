class User < ActiveRecord::Base
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :full_name, presence: true

  has_secure_password

  has_many :reviews

  before_create { self.email = email.downcase }
end
