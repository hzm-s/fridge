# typed: strict
require 'sorbet-runtime'

module ProductBacklogItemRepository
  module AR
    class << self
      extend T::Sig
      include Pbi::ItemRepository

      sig {override.params(id: Pbi::ItemId).returns(Pbi::Item)}
      def find_by_id(id)
        r = Dao::ProductBacklogItem.eager_load(:criteria).find(id)
        Pbi::Item.from_repository(
          Pbi::ItemId.from_repository(r.id),
          Product::ProductId.from_repository(r.dao_product_id),
          Pbi::Content.from_repository(r.content),
          Pbi::StoryPoint.from_repository(r.size),
          Pbi::AcceptanceCriteria.from_repository(r.criteria.map(&:content))
        )
      end

      sig {override.params(pbi: Pbi::Item).void}
      def add(pbi)
        Dao::ProductBacklogItem.create!(
          id: pbi.id.to_s,
          dao_product_id: pbi.product_id.to_s,
          content: pbi.content.to_s,
          size: pbi.size.to_i
        )
      end

      sig {override.params(pbi: Pbi::Item).void}
      def update(pbi)
        r = Dao::ProductBacklogItem.find(pbi.id.to_s)
        r.content = pbi.content.to_s
        r.size = pbi.size.to_i

        r.criteria.clear
        pbi.acceptance_criteria.to_a.each { |c| r.criteria.build(content: c) }

        r.save!
      end
    end
  end
end
