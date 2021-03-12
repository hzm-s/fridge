# typed: strict
require 'sorbet-runtime'

module Plan
  module ReleaseRepository
    extend T::Sig
    extend T::Helpers
    interface!

    sig {abstract.returns(Integer)}
    def next_number; end

    sig {abstract.params(product_id: Product::Id).returns(Release)}
    def find_by_product_id(product_id); end

    sig {abstract.params(release: Release).void}
    def store(release); end
  end
end
