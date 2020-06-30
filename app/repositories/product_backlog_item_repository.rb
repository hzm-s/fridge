module ProductBacklogItemRepository
  module AR
    class << self
      def add(pbi)
        Dao::ProductBacklogItem.create!(
          id: pbi.id.to_s,
          content: pbi.content.to_s
        )
      end

      def find_by_id(id)
        r = Dao::ProductBacklogItem.find(id)
        Product::BacklogItem.from_repository(
          Product::BacklogItemId.from_repository(r.id),
          r.content
        )
      end
    end
  end
end
