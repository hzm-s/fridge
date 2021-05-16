# typed: strict
require 'sorbet-runtime'

module WorkRepository
  class AR
    class << self
      extend T::Sig
      include Work::WorkRepository

      sig {override.params(work: Work::Work).void}
      def store(work)
        dao = Dao::Work.new(dao_issue_id: work.issue_id.to_s)
        dao.write(work)
        dao.save!
      end
    end
  end
end
