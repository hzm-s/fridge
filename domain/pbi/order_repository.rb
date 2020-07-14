# typed: strict
require 'sorbet-runtime'

module Pbi
  module OrderRepository
    extend T::Sig
    extend T::Helpers
    interface!

    sig {abstract.params(product_id: Product::ProductId).returns(T.nilable(Order))}
    def find_by_product_id(product_id); end

    sig {abstract.params(order: Order).void}
    def update(order); end
  end
end
