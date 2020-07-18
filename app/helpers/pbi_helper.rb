# typed: true
module PbiHelper
  def present_story_point(point)
    Pbi::StoryPoint.from_integer(point).to_s
  end

  def all_story_points
    Pbi::StoryPoint.all.map(&:to_s)
  end
end
