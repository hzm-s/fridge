# typed: strict
require 'sorbet-runtime'

module ProductBacklogItemRepository
  module AR
    class << self
      extend T::Sig
      include Pbi::ItemRepository

      sig {override.params(id: Pbi::Id).returns(Pbi::Item)}
      def find_by_id(id)
        r = Dao::ProductBacklogItem.eager_load(:criteria).find(id)
        Pbi::Item.from_repository(
          Pbi::Id.from_string(r.id),
          Product::Id.from_string(r.dao_product_id),
          Pbi::Statuses.from_string(r.status),
          Pbi::Content.new(r.content),
          Pbi::StoryPoint.new(r.size),
          r.criteria.map { |c| Pbi::AcceptanceCriterion.new(c.content) }
            .yield_self { |criteria| Pbi::AcceptanceCriteria.new(criteria) }
        )
      end

      sig {override.params(pbi: Pbi::Item).void}
      def add(pbi)
        Dao::ProductBacklogItem.create!(
          id: pbi.id.to_s,
          dao_product_id: pbi.product_id.to_s,
          status: pbi.status.to_s,
          content: pbi.content.to_s,
          size: pbi.size.to_i,
        )
      end

      sig {override.params(pbi: Pbi::Item).void}
      def update(pbi)
        r = Dao::ProductBacklogItem.find(pbi.id.to_s)
        r.status = pbi.status.to_s
        r.content = pbi.content.to_s
        r.size = pbi.size.to_i

        r.criteria.clear
        pbi.acceptance_criteria.to_a.each do |ac|
          r.criteria.build(content: ac.to_s)
        end

        r.save!
      end

      sig {override.params(id: Pbi::Id).void}
      def delete(id)
        Dao::ProductBacklogItem.destroy(id.to_s)
      end
    end
  end
end
