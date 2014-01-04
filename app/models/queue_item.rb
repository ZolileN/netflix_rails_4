class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  delegate :title, to: :video, prefix: :video
  delegate :category, to: :video

  def category_name
    category.name
  end

  def rating
    review = Review.find_by(user_id: user.id, video_id: video.id)
    review.rating if review
  end
end
