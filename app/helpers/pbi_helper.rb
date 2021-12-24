# typed: true
module PbiHelper
  def present_story_point(point)
    Pbi::StoryPoint.new(point).to_s
  end

  def all_story_points
    Pbi::StoryPoint.all.map(&:to_s)
  end

  def all_pbi_types
    Pbi::Types.values
  end

  def all_pbi_statuses
    Pbi::Statuses.all.map(&:to_s)
  end

  def global_criterion_params(criterion, extras = {})
    { pbi_id: criterion.pbi_id, number: criterion.number }.merge(extras)
  end

  def criterion_dom_id(criterion, prefix)
    "#{prefix}-#{criterion.pbi_id}-#{criterion.number}"
  end

  def build_criterion_form(criterion)
    AcceptanceCriterionForm.new(content: criterion.content)
  end
end
