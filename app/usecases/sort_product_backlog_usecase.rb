# typed: strict
require 'sorbet-runtime'

class SortProductBacklogUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(PlanRepository::AR, Plan::PlanRepository)
  end

  sig {params(product_id: Product::Id, from_no: Integer, item: Pbi::Id, to_no: Integer, position: Integer).void}
  def perform(product_id, from_no, item, to_no, position)
    plan = @repository.find_by_product_id(product_id)

    from = plan.release(from_no)
    to = plan.release(to_no)

    if from_no == to_no
      destination = to.items[position - 1]
      to.swap_priorities(item, T.must(destination))
    else
      from.remove_item(item)
      to.add_item(item)
      destination = to.items[position - 1]
      to.swap_priorities(item, T.must(destination))
    end

    plan.replace_release(from_no, from)
    plan.replace_release(to_no, to)

    transaction do
      @repository.update(plan)
    end
  end
end
