# typed: strict
require 'sorbet-runtime'

class ScheduleIssueUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(PlanRepository::AR, Plan::PlanRepository)
  end

  sig {params(product_id: Product::Id, issue_id: Issue::Id, release_name: String, to_index: Integer).void}
  def perform(product_id, issue_id, release_name, to_index)
    plan = @repository.find_by_product_id(product_id)

    pending = plan.pending.remove(issue_id)
    plan.update_pending(pending)

    release = plan.scheduled.get(release_name)
    new_release =
      if release.issues.empty? || release.issues.to_a.size <= to_index
        release.append_issue(issue_id)
      else
        release.append_issue(issue_id).change_issue_priority(issue_id, release.issue_at(to_index))
      end
    new_releases = plan.scheduled.update(new_release)

    plan.update_scheduled(new_releases)

    @repository.store(plan)
  end
end
