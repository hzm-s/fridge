# typed: strict
require 'sorbet-runtime'

class PrepareOrderUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(OrderRepository::AR, Plan::OrderRepository)
  end

  sig {params(product_id: Product::Id).void}
  def perform(product_id)
    order = Plan::Order.create(product_id)
    @repository.store(order)
  end
end
