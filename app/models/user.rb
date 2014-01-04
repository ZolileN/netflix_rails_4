class User < ActiveRecord::Base
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :full_name, presence: true

  has_secure_password

  has_many :reviews
  has_many :queue_items, -> { order :position }

  before_create { self.email = email.downcase }

  def queued_video?(video)
    queue_items.map(&:video).include?(video)
  end

  def normalize_queue_item_positions
    queue_items.each_with_index do |queue_item, index|
      queue_item.update_attribute(:position, index + 1)
    end
  end
end
