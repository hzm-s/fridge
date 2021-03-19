# typed: strict
require 'sorbet-runtime'

class PlannedIssueResolver < UsecaseBase
  extend T::Sig

  class << self
    extend T::Sig

    sig {params(plan: Plan::Plan, release_number: Integer, index: Integer).returns(T.nilable(Issue::Id))}
    def resolve_issue(plan, release_number, index)
      new(plan).resolve_issue(release_name, index)
    end
  end

  sig {params(plan: Plan::Plan).void}
  def initialize(plan)
    @plan = plan
  end

  sig {params(issue_id: Issue::Id).returns(T.nilable(Plan::Release))}
  def resolve_release(issue_id)
    @plan.releases.find { |r| r.include?(issue_id) }
  end
end
