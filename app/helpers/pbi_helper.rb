# typed: true
module PbiHelper
  STATUS_FILTER_CLASSES_BASE = 'pbl__filter btn'.freeze

  def present_story_point(point)
    Pbi::StoryPoint.new(point).to_s
  end

  def all_story_points
    Pbi::StoryPoint.all.map(&:to_s)
  end

  def all_pbi_statuses
    Pbi::Statuses.all.map(&:to_s)
  end

  def pbl_status_filter_classes(current:, filter:)
    "#{STATUS_FILTER_CLASSES_BASE} btn-#{current == filter ? '' : 'outline-'}secondary"
  end
end
