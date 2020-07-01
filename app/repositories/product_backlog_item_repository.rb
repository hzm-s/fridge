# typed: strict
require 'sorbet-runtime'

module ProductBacklogItemRepository
  module AR
    class << self
      extend T::Sig
      include Pbi::ItemRepository

      sig {override.params(pbi: Pbi::Item).void}
      def add(pbi)
        Dao::ProductBacklogItem.create!(
          id: pbi.id.to_s,
          content: pbi.content.to_s
        )
      end

      sig {override.params(id: Pbi::ItemId).returns(Pbi::Item)}
      def find_by_id(id)
        r = Dao::ProductBacklogItem.find(id)
        Pbi::Item.from_repository(
          Pbi::ItemId.from_repository(r.id),
          Pbi::Content.from_repository(r.content)
        )
      end
    end
  end
end
