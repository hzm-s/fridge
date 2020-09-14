# typed: true
require 'sorbet-runtime'

module PbiRepository
  class AR < Dao::Pbi
    class << self
      extend T::Sig
      include Issue::IssueRepository

      sig {override.params(id: Pbi::Id).returns(Pbi::Pbi)}
      def find_by_id(id)
        eager_load(:criteria).find(id).read
      end

      sig {override.params(pbi: Pbi::Pbi).void}
      def store(pbi)
        find_or_initialize_by(id: pbi.id.to_s).tap do |dao|
          dao.write(pbi)
          dao.save!
        end
      end

      sig {override.params(id: Pbi::Id).void}
      def delete(id)
        destroy(id.to_s)
      end
    end

    def write(pbi)
      self.attributes = {
        dao_product_id: pbi.product_id.to_s,
        status: pbi.status.to_s,
        description: pbi.description.to_s,
        size: pbi.size.to_i,
      }

      self.criteria.clear
      pbi.acceptance_criteria.to_a.each do |ac|
        self.criteria.build(content: ac.to_s)
      end
    end

    def read
      Pbi::Pbi.from_repository(
        read_pbi_id,
        read_product_id,
        read_status,
        read_description,
        read_story_point,
        read_acceptance_criteria
      )
    end

    def read_pbi_id
      Pbi::Id.from_string(id)
    end

    def read_product_id
      Product::Id.from_string(dao_product_id)
    end

    def read_status
      Pbi::Statuses.from_string(status)
    end

    def read_description
      Pbi::Description.new(description)
    end

    def read_story_point
      Pbi::StoryPoint.new(size)
    end

    def read_acceptance_criteria
      criteria
        .map { |c| Pbi::AcceptanceCriterion.new(c.content) }
        .yield_self { |c| Pbi::AcceptanceCriteria.new(c) }
    end
  end
end
