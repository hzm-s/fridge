# typed: strict
require 'sorbet-runtime'

class PendIssueUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(PlanRepository::AR, Plan::PlanRepository)
  end

  sig {params(product_id: Product::Id, roles: Team::RoleSet, issue_id: Issue::Id, release_name: String).void}
  def perform(product_id, roles, issue_id, release_name)
    plan = @repository.find_by_product_id(product_id)

    plan.remove_issue(roles, issue_id)
    new_pending = plan.pending.add_to_first(issue_id)

    plan.update_pending(new_pending)
    @repository.store(plan)
  end
end
