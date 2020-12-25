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

    release = plan.scheduled.get(release_name)
    target_issue = release.issue_at(to_index)
    return unless target_issue

    new_release = release.change_issue_priority(issue_id, target_issue)

    new_releases = plan.scheduled.update(new_release)
    plan.update_scheduled(new_releases)

    @repository.store(plan)
  end
end
