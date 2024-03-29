# typed: strict
require 'sorbet-runtime'

module Roadmap
  module RoadmapRepository
    extend T::Sig
    extend T::Helpers
    interface!

    sig {abstract.params(product_id: Product::Id).returns(Roadmap)}
    def find_by_product_id(product_id); end

    sig {abstract.params(roadmap: Roadmap).void}
    def store(roadmap); end
  end
end
