# typed: strict
require 'sorbet-runtime'

class PlannedIssueQuery
  extend T::Sig

  class << self
    extend T::Sig

    sig {params(plan: Plan::Plan, release_number: Integer, index: Integer).returns(T.nilable(Issue::Id))}
    def call(plan, release_number, index)
      new(plan).call(release_number, index)
    end
  end

  sig {params(plan: Plan::Plan).void}
  def initialize(plan)
    @plan = plan
  end

  sig {params(release_number: Integer, index: Integer).returns(T.nilable(Issue::Id))}
  def call(release_number, index)
    release = @plan.release_of(release_number)
    return nil unless release

    release.issues.to_a[index]
  end
end
