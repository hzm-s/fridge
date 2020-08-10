# typed: strict
require 'sorbet-runtime'

class AddProductBacklogItemUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @pbi_repository = T.let(ProductBacklogItemRepository::AR, Pbi::ItemRepository)
    @plan_repository = T.let(PlanRepository::AR, Plan::PlanRepository)
  end

  sig {params(product_id: Product::Id, content: Pbi::Content).returns(Pbi::Id)}
  def perform(product_id, content)
    pbi = Pbi::Item.create(product_id, content)

    transaction do
      plan = find_plan(product_id)
      plan.add_item(pbi.id)
      @pbi_repository.add(pbi)
      @plan_repository.update(plan)
    end

    pbi.id
  end

  private

  sig {params(product_id: Product::Id).returns(Plan::Plan)}
  def find_plan(product_id)
    plan = @plan_repository.find_by_product_id(product_id)
    return Plan::Plan.create(product_id) unless plan

    plan
  end
end
