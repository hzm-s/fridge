# typed: strict
require 'sorbet-runtime'

class RemoveIssueFromPlanUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(PlanRepository::AR, Plan::PlanRepository)
  end

  sig {params(product_id: Product::Id, roles: Team::RoleSet, issue_id: Issue::Id).void}
  def perform(product_id, roles, issue_id)
    plan = @repository.find_by_product_id(product_id)
    plan.remove_issue(roles, issue_id)
    @repository.store(plan)
  end
end
