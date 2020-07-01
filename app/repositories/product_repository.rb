# typed: strict
require 'sorbet-runtime'

module ProductRepository
  module AR
    class << self
      extend T::Sig
      include Product::ProductRepository

      sig {override.params(product: Product::Product).void}
      def add(product)
        Dao::Product.create!(
          id: product.id.to_s,
          name: product.name.to_s,
          description: product.description.to_s
        )
      end
    end
  end
end
