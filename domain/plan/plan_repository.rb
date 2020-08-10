# typed: strict
require 'sorbet-runtime'

module Plan
  module PlanRepository
    extend T::Sig
    extend T::Helpers
    interface!

    sig {params(id: Product::Id).returns(Plan)}
    def find_by_product_id(id); end

    sig {params(plan: Plan).void}
    def add(plan); end
  end
end
