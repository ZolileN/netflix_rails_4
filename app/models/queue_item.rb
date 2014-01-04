class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  delegate :title, to: :video, prefix: :video
  delegate :category, to: :video

  validates_numericality_of :position, only_integer: true

  def category_name
    category.name
  end

  def rating
    review = Review.find_by(user_id: user.id, video_id: video.id)
    review.rating if review
  end
end
