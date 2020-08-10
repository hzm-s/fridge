# typed: strict
require 'sorbet-runtime'

module Plan
  module PlanRepository
    extend T::Sig
    extend T::Helpers
    interface!

    sig {abstract.params(id: Product::Id).returns(Plan)}
    def find_by_product_id(id); end

    sig {abstract.params(plan: Plan).void}
    def add(plan); end

    sig {abstract.params(plan: Plan).void}
    def update(plan); end
  end
end
