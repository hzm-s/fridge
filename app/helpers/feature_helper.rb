# typed: true
module FeatureHelper
  def present_story_point(point)
    Feature::StoryPoint.new(point).to_s
  end

  def all_story_points
    Feature::StoryPoint.all.map(&:to_s)
  end

  def all_pbi_statuses
    Feature::Statuses.all.map(&:to_s)
  end
end
