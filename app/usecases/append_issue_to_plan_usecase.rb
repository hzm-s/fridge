# typed: strict
require 'sorbet-runtime'

class AppendIssueToPlanUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(PlanRepository::AR, Plan::PlanRepository)
  end

  sig {params(product_id: Product::Id, issue_id: Issue::Id).void}
  def perform(product_id, issue_id)
    plan = @repository.find_by_product_id(product_id)

    new_order = plan.order.append(issue_id)
    plan.specify_order(new_order)

    @repository.store(plan)
  end
end
