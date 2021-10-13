# typed: strict
require 'sorbet-runtime'

module WorkRepository
  class AR
    class << self
      extend T::Sig
      include Work::WorkRepository

      sig {override.params(issue_id: Issue::Id).returns(Work::Work)}
      def find_by_issue_id(issue_id)
        Dao::Work.find_by!(dao_issue_id: issue_id).read
      end

      sig {override.params(work: Work::Work).void}
      def store(work)
        dao = Dao::Work.find_or_initialize_by(dao_issue_id: work.issue_id.to_s)
        dao.write(work)
        dao.save!
      end
    end
  end
end
