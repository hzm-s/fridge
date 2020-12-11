# typed: strict
require 'sorbet-runtime'

class RemoveIssueFromReleaseUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(PlanRepository::AR, Plan::PlanRepository)
  end

  sig {params(product_id: Product::Id, issue_id: Issue::Id, release_name: String).void}
  def perform(product_id, issue_id, release_name)
    plan = @repository.find_by_product_id(product_id)

    release = plan.scoped.get(release_name)
    new_release = release.remove_issue(issue_id)
    new_scoped = plan.scoped.update(new_release)
    plan.update_scoped(new_scoped)

    not_scoped = plan.not_scoped
    new_not_scoped =
      if not_scoped.empty?
        not_scoped.append(issue_id)
      else
        not_scoped.append(issue_id).swap(issue_id, not_scoped.at(0))
      end
    plan.update_not_scoped(new_not_scoped)

    @repository.store(plan)
  end
end