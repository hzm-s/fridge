# typed: strict
require 'sorbet-runtime'

class PlannedIssueResolver < UsecaseBase
  extend T::Sig

  sig {params(plan: Plan::Plan).void}
  def initialize(plan)
    @pending = T.let(plan.pending, Plan::IssueList)
    @scheduled = T.let(plan.scheduled, Plan::ReleaseList)
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
