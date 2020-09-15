# typed: true
require 'sorbet-runtime'

module IssueRepository
  class AR < Dao::Issue
    class << self
      extend T::Sig
      include Issue::IssueRepository

      sig {override.params(id: Issue::Id).returns(Issue::Issue)}
      def find_by_id(id)
        eager_load(:criteria).find(id).read
      end

      sig {override.params(issue: Issue::Issue).void}
      def store(issue)
        find_or_initialize_by(id: issue.id.to_s).tap do |dao|
          dao.write(issue)
          dao.save!
        end
      end

      sig {override.params(id: Issue::Id).void}
      def delete(id)
        destroy(id.to_s)
      end
    end

    def write(issue)
      self.attributes = {
        dao_product_id: issue.product_id.to_s,
        status: issue.status.to_s,
        description: issue.description.to_s,
        size: issue.size.to_i,
      }

      self.criteria.clear
      issue.acceptance_criteria.to_a.each do |ac|
        self.criteria.build(content: ac.to_s)
      end
    end

    def read
      Issue::Issue.from_repository(
        read_issue_id,
        read_product_id,
        read_status,
        read_description,
        read_story_point,
        read_acceptance_criteria
      )
    end

    def read_issue_id
      Issue::Id.from_string(id)
    end

    def read_product_id
      Product::Id.from_string(dao_product_id)
    end

    def read_status
      Issue::Statuses.from_string(status)
    end

    def read_description
      Issue::Description.new(description)
    end

    def read_story_point
      Issue::StoryPoint.new(size)
    end

    def read_acceptance_criteria
      criteria
        .map { |c| Issue::AcceptanceCriterion.new(c.content) }
        .yield_self { |c| Issue::AcceptanceCriteria.new(c) }
    end
  end
end
