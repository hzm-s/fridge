# typed: true
module PbiHelper
  def present_story_point(point)
    Pbi::StoryPoint.new(point).to_s
  end

  def all_story_points
    Pbi::StoryPoint.all.map(&:to_s)
  end

  def all_pbi_statuses
    Pbi::Statuses.all.map(&:to_s)
  end
end
