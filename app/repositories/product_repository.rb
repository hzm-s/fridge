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

      sig {override.params(id: Product::ProductId).returns(Product::Product)}
      def find_by_id(id)
        r = Dao::Product.find(id)
        Product::Product.from_repository(
          Product::ProductId.from_repository(r.id),
          r.name,
          r.description
        )
      end
    end
  end
end
