# typed: false
module ApplicationHelper
  def authorize(target, *activity_set_providers)
    Activity.allow?(target.to_sym, activity_set_providers)
  end
end
