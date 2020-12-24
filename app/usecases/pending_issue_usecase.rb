# typed: strict
require 'sorbet-runtime'

class PendingIssueUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(PlanRepository::AR, Plan::PlanRepository)
  end

  sig {params(product_id: Product::Id, issue_id: Issue::Id, release_name: String).void}
  def perform(product_id, issue_id, release_name)
    plan = @repository.find_by_product_id(product_id)

    release = plan.scheduled.get(release_name)
    new_release = release.remove_issue(issue_id)
    new_scheduled = plan.scheduled.update(new_release)
    plan.update_scheduled(new_scheduled)

    pending = plan.pending
    new_pending =
      if pending.empty?
        pending.append(issue_id)
      else
        pending.append(issue_id).swap(issue_id, pending.at(0))
      end
    plan.update_pending(new_pending)

    @repository.store(plan)
  end
end
