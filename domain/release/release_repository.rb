# typed: strict
require 'sorbet-runtime'

module Release
  module ReleaseRepository
    extend T::Sig
    extend T::Helpers
    interface!

    sig {abstract.params(product_id: Product::Id).returns(T::Array[Release])}
    def all_by_product_id(product_id); end

    sig {abstract.params(id: Id).returns(Release)}
    def find_by_id(id); end

    sig {abstract.params(release: Release).void}
    def add(release); end

    sig {abstract.params(release: Release).void}
    def update(release); end

    sig {abstract.params(id: Id).void}
    def remove(id); end
  end
end
