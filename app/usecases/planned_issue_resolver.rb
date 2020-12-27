# typed: strict
require 'sorbet-runtime'

class PlannedIssueResolver < UsecaseBase
  extend T::Sig

  sig {params(plan: Plan::Plan).void}
  def initialize(plan)
    @pending = plan.pending
    @scheduled = plan.scheduled
  end

  sig {params(index: Integer).returns(T.nilable(Issue::Id))}
  def resolve_pending(index)
    @pending.to_a[index]
  end

  sig {params(release_name: String, index: Integer).returns(T.nilable(Issue::Id))}
  def resolve_scheduled(release_name, index)
    @scheduled.get(release_name).issues.to_a[index]
  end
end
