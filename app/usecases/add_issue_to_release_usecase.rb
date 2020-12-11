# typed: strict
require 'sorbet-runtime'

class AddIssueToReleaseUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(PlanRepository::AR, Plan::PlanRepository)
  end

  sig {params(product_id: Product::Id, issue_id: Issue::Id, release_name: String, to_index: Integer).void}
  def perform(product_id, issue_id, release_name, to_index)
    plan = @repository.find_by_product_id(product_id)

    not_scoped = plan.not_scoped.remove(issue_id)
    plan.update_not_scoped(not_scoped)

    release = plan.scoped.get(release_name)
    new_release =
      if release.issues.empty?
        release.append_issue(issue_id)
      else
        release.append_issue(issue_id).change_issue_priority(issue_id, release.issue_at(to_index))
      end
    new_releases = plan.scoped.update(new_release)

    plan.update_scoped(new_releases)

    @repository.store(plan)
  end
end
