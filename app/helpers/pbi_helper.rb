# typed: true
module PbiHelper
  def present_story_point(point)
    Issue::StoryPoint.new(point).to_s
  end

  def all_story_points
    Issue::StoryPoint.all.map(&:to_s)
  end

  def all_issue_types
    Issue::Types.all
  end

  def all_pbi_statuses
    Issue::Statuses.all.map(&:to_s)
  end
  
  def global_criterion_params(criterion, extras = {})
    { issue_id: criterion.issue_id, number: criterion.number }.merge(extras)
  end

  def criterion_dom_id(criterion, prefix)
    "#{prefix}-#{criterion.issue_id}-#{criterion.number}"
  end
end
