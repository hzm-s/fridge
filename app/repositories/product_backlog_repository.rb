# typed: strict
require 'sorbet-runtime'

module ProductBacklogRepository
  module AR
    class << self
      extend T::Sig
      include ProductBacklog::ProductBacklogRepository

      sig {override.params(product_id: Product::Id).returns(T.nilable(ProductBacklog::ProductBacklog))}
      def find_by_product_id(product_id)
        r = Dao::ProductBacklog.find_by(dao_product_id: product_id.to_s)
        return nil unless r

        ProductBacklog::ProductBacklog.from_repository(
          r.product_id_as_do,
          r.items_as_do
        )
      end

      sig {override.params(pbl: ProductBacklog::ProductBacklog).void}
      def add(pbl)
        Dao::ProductBacklog.create!(
          dao_product_id: pbl.product_id.to_s,
          items: pbl.items.map(&:to_s)
        )
      end

      sig {override.params(pbl: ProductBacklog::ProductBacklog).void}
      def update(pbl)
        r = Dao::ProductBacklog.find_by(dao_product_id: pbl.product_id.to_s)
        return add(pbl) unless r

        r.items = pbl.items.map(&:to_s)
        r.save!
      end
    end
  end
end
