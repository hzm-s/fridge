# typed: strict
require 'sorbet-runtime'

class PlannedIssueResolver < UsecaseBase
  extend T::Sig

  class << self
    extend T::Sig

    sig {params(plan: Plan::Plan, release_name: String, index: Integer).returns(T.nilable(Issue::Id))}
    def resolve_scheduled(plan, release_name, index)
      new(plan).resolve_scheduled(release_name, index)
    end
  end

  sig {params(plan: Plan::Plan).void}
  def initialize(plan)
    @scheduled = T.let(plan.scheduled, Plan::ReleaseList)
  end

  sig {params(release_name: String, index: Integer).returns(T.nilable(Issue::Id))}
  def resolve_scheduled(release_name, index)
    @scheduled.get(release_name).issues.to_a[index]
  end
end
