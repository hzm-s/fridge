# typed: true
module PbiHelper
  def present_story_point(point)
    Issue::StoryPoint.new(point).to_s
  end

  def all_story_points
    Issue::StoryPoint.all.map(&:to_s)
  end

  def all_pbi_statuses
    Issue::Statuses.all.map(&:to_s)
  end
end
