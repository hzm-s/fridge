# typed: strict
require 'sorbet-runtime'

module ProductBacklogItemRepository
  module AR
    class << self
      extend T::Sig
      include Product::BacklogItemRepository

      sig {override.params(pbi: Product::BacklogItem).void}
      def add(pbi)
        Dao::ProductBacklogItem.create!(
          id: pbi.id.to_s,
          content: pbi.content.to_s
        )
      end

      sig {override.params(id: Product::BacklogItemId).returns(Product::BacklogItem)}
      def find_by_id(id)
        r = Dao::ProductBacklogItem.find(id)
        Product::BacklogItem.from_repository(
          Product::BacklogItemId.from_repository(r.id),
          Product::BacklogItemContent.from_repository(r.content)
        )
      end
    end
  end
end
