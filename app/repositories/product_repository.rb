# typed: false
require 'sorbet-runtime'

module ProductRepository
  module AR
    class << self
      extend T::Sig
      include Product::ProductRepository

      sig {override.params(id: Product::Id).returns(Product::Product)}
      def find_by_id(id)
        Dao::Product.find(id.to_s).read
      end

      sig {override.params(product: Product::Product).void}
      def store(product)
        dao = Dao::Product.find_or_initialize_by(id: product.id.to_s)
        dao.write(product)
        dao.save!
      end
    end
  end
end
