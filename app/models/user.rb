class User < ActiveRecord::Base
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :full_name, presence: true

  has_secure_password

  has_many :reviews
  has_many :queue_items, -> { order :position }
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :reverse_relationships, source: :follower

  before_create { self.email = email.downcase }
  before_create :generate_token

  def queued_video?(video)
    queue_items.map(&:video).include?(video)
  end

  def normalize_queue_item_positions
    queue_items.each_with_index do |queue_item, index|
      queue_item.update(:position, index + 1)
    end
  end

  def can_follow?(another_user)
    !(followed_users.include?(another_user) || self == another_user)
  end

  def generate_token
    self.token = SecureRandom.urlsafe_base64
  end
end
