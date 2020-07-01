# typed: strict
require 'sorbet-runtime'

module Product
  module BacklogItemOrderRepository
    extend T::Sig
    extend T::Helpers
    interface!

    sig {abstract.params(product_id: ProductId).returns(T.nilable(BacklogItemOrder))}
    def find_by_product_id(product_id); end

    sig {abstract.params(order: BacklogItemOrder).void}
    def update(order); end
  end
end
