# typed: strict
require 'sorbet-runtime'

class ChangeReleaseOfIssueUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(PlanRepository::AR, Plan::PlanRepository)
  end

  sig {params(product_id: Product::Id, issue_id: Issue::Id, from_name: String, to_name: String, to_index: Integer).void}
  def perform(product_id, issue_id, from_name, to_name, to_index)
    plan = @repository.find_by_product_id(product_id)

    resolver = PlannedIssueResolver.new(plan)
    target_issue_id = resolver.resolve_scheduled(to_name, to_index)

    new_scheduled = plan.scheduled.reschedule_issue(issue_id, from_name, to_name)
    if target_issue_id
      new_scheduled = new_scheduled.change_issue_priority(to_name, issue_id, target_issue_id)
    end

    plan.update_scheduled(new_scheduled)

    @repository.store(plan)
  end
end
