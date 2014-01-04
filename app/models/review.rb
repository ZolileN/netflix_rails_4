class Review < ActiveRecord::Base
  validates :rating, presence: true, numericality: { only_integer: true }
  validates :content, presence: true

  belongs_to :video
  belongs_to :user

  delegate :title, to: :video, prefix: :video
end
