# typed: strict
require 'sorbet-runtime'

class ChangeReleaseOfIssueUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(PlanRepository::AR, Plan::PlanRepository)
  end

  sig {params(product_id: Product::Id, issue_id: Issue::Id, src_name: String, dst_name: String, to_index: Integer).void}
  def perform(product_id, issue_id, src_name, dst_name, to_index)
    plan = @repository.find_by_product_id(product_id)

    new_src = plan.scoped.get(src_name).remove_issue(issue_id)
    tmp_scoped = plan.scoped.update(new_src)

    dst = tmp_scoped.get(dst_name)
    new_dst =
      if dst.issues.empty?
        dst.append_issue(issue_id)
      else
        dst.append_issue(issue_id).change_issue_priority(issue_id, dst.issues.at(to_index))
      end
    new_scoped = tmp_scoped.update(new_dst)

    plan.update_scoped(new_scoped)

    @repository.store(plan)
  end
end
