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

    release = plan.scoped.get(release_name)
    new_release = release.swap_issues(issue_id, release.issues.at(to_index))

    new_releases = plan.scoped.update(new_release)
    plan.update_scoped(new_releases)

    @repository.store(plan)
  end
end
