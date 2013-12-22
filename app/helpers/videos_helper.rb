module VideosHelper
  def options_for_video_reviews(selected=nil)
    options_for_select(5.downto(1).map {|rating| [pluralize(rating, "Star"), rating]}, selected)
  end
end
