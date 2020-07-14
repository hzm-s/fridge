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
          Pbi::Id.from_repository(r.id),
          Product::ProductId.from_repository(r.dao_product_id),
          Pbi::Content.from_repository(r.content),
          Pbi::StoryPoint.from_repository(r.size),
          Pbi::AcceptanceCriteria.from_repository(
            r.next_acceptance_criterion_no,
            r.criteria.map { |c| Pbi::AcceptanceCriterion.from_repository(c.no, c.content) }
          )
        )
      end

      sig {override.params(pbi: Pbi::Item).void}
      def add(pbi)
        Dao::ProductBacklogItem.create!(
          id: pbi.id.to_s,
          dao_product_id: pbi.product_id.to_s,
          content: pbi.content.to_s,
          size: pbi.size.to_i,
          next_acceptance_criterion_no: pbi.acceptance_criteria.next_no
        )
      end

      sig {override.params(pbi: Pbi::Item).void}
      def update(pbi)
        r = Dao::ProductBacklogItem.find(pbi.id.to_s)
        r.content = pbi.content.to_s
        r.size = pbi.size.to_i
        r.next_acceptance_criterion_no = pbi.acceptance_criteria.next_no

        r.criteria.clear
        pbi.acceptance_criteria.list.each do |c|
          r.criteria.build(no: c.no, content: c.content)
        end

        r.save!
      end
    end
  end
end
