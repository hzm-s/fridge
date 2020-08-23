# typed: strict
require 'sorbet-runtime'

module ProductBacklog
  module ProductBacklogRepository
    extend T::Sig
    extend T::Helpers
    interface!

    sig {abstract.params(product_id: Product::Id).returns(T.nilable(ProductBacklog))}
    def find_by_product_id(product_id); end

    sig {abstract.params(pbl: ProductBacklog).void}
    def add(pbl); end

    sig {abstract.params(pbl: ProductBacklog).void}
    def update(pbl); end
  end
end
