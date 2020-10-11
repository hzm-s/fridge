# typed: strict
require 'sorbet-runtime'

module Plan
  module OrderRepository
    extend T::Sig
    extend T::Helpers
    interface!

    sig {abstract.params(product_id: Product::Id).returns(Order)}
    def find_by_product_id(product_id); end

    sig {abstract.params(order: Order).void}
    def store(order); end
  end
end
