class User < ActiveRecord::Base
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :full_name, presence: true

  has_secure_password

  has_many :reviews
  has_many :queue_items

  before_create { self.email = email.downcase }

  def queued_video?(video)
    queue_items.map(&:video).include?(video)
  end
end
