# typed: false
module ApplicationHelper
  def authorize(target, *activity_set_providers)
    Activity.allow?(target.to_sym, activity_set_providers)
  end

  def authorize_any(targets, *activity_set_providers)
    targets.any? { |t| authorize(t, *activity_set_providers) }
  end
end
