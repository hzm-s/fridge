# typed: strict
require 'sorbet-runtime'

class PlanIssueUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @issue_repository = T.let(IssueRepository::AR, Issue::IssueRepository)
    @plan_repository = T.let(PlanRepository::AR, Plan::PlanRepository)
  end

  sig {params(product_id: Product::Id, type: Issue::Type, description: Issue::Description).returns(Issue::Id)}
  def perform(product_id, type, description)
    issue = Issue::Issue.create(product_id, type, description)
    @issue_repository.store(issue)

    plan = @plan_repository.find_by_product_id(product_id)
    plan.recent_release.tap do |r|
      r.append_issue(issue.id)
      plan.update_release(r)
    end
    @plan_repository.store(plan)

    issue.id
  end
end
