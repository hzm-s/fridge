# typed: strict
require 'sorbet-runtime'

class SwapOrderedIssuesUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(OrderRepository::AR, Order::OrderRepository)
  end

  sig {params(product_id: Product::Id, from: Issue::Id, to: Issue::Id).void}
  def perform(product_id, from, to)
    order = @repository.find_by_product_id(product_id)
    order.swap_issues(from, to)
    @repository.store(order)
  end
end
