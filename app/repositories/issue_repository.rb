# typed: strict
require 'sorbet-runtime'

module IssueRepository
  class AR
    class << self
      extend T::Sig
      include Issue::IssueRepository

      sig {override.params(id: Issue::Id).returns(Issue::Issue)}
      def find_by_id(id)
        Dao::Issue.eager_load(:criteria).find(id.to_s).read
      rescue ActiveRecord::RecordNotFound
        raise Issue::NotFound
      end

      sig {override.params(issue: Issue::Issue).void}
      def store(issue)
        Dao::Issue.find_or_initialize_by(id: issue.id.to_s).tap do |dao|
          dao.write(issue)
          dao.save!
        end
      end

      sig {override.params(id: Issue::Id).void}
      def remove(id)
        Dao::Issue.destroy(id.to_s)
      end
    end
  end
end
