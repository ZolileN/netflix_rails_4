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
    review.rating if review
  end

  def rating=(new_rating)
    if review
      review.update_column(:rating, new_rating)
    else
      review = Review.new(rating: new_rating, video: video, user: user)
      review.save(validate: false)
    end
  end

  def review
    Review.find_by(user_id: user.id, video_id: video.id)
  end
end
