# typed: strict
require 'sorbet-runtime'

class ChangeIssuePriorityUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(PlanRepository::AR, Plan::PlanRepository)
  end

  sig {params(product_id: Product::Id, release_name: String, issue_id: Issue::Id, to_index: Integer).void}
  def perform(product_id, release_name, issue_id, to_index)
    plan = @repository.find_by_product_id(product_id)
    target_issue_id = T.must(PlannedIssueResolver.resolve_scheduled(plan, release_name, to_index))

    new_releases = plan.scheduled.change_issue_priority(release_name, issue_id, target_issue_id)

    plan.update_scheduled(new_releases)
    @repository.store(plan)
  end
end
