# typed: strict
require 'sorbet-runtime'

module Plan
  module PlanRepository
    extend T::Sig
    extend T::Helpers
    interface!

    sig {abstract.params(product_id: Product::Id).returns(Plan)}
    def find_by_product_id(product_id); end

    sig {abstract.params(order: Plan).void}
    def store(order); end
  end
end
