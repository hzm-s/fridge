# typed: strict
require 'sorbet-runtime'

module Release
  module ReleaseRepository
    extend T::Sig
    extend T::Helpers
    interface!

    sig {abstract.params(product_id: Product::Id).returns(Release)}
    def find_by_product_id(product_id); end

    sig {abstract.params(plan: Plan).void}
    def store(plan); end
  end
end
