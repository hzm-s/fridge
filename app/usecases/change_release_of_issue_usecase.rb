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

    new_src = plan.scheduled.get(src_name).remove_issue(issue_id)
    tmp_scheduled = plan.scheduled.update(new_src)

    dst = tmp_scheduled.get(dst_name)
    new_dst =
      if dst.issues.empty? || dst.issue_at(to_index).nil?
        dst.append_issue(issue_id)
      else
        dst.append_issue(issue_id).change_issue_priority(issue_id, dst.issue_at(to_index))
      end
    new_scheduled = tmp_scheduled.update(new_dst)

    plan.update_scheduled(new_scheduled)

    @repository.store(plan)
  end
end
