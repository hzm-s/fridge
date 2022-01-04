# typed: strict
require 'sorbet-runtime'

module WorkRepository
  class AR
    class << self
      extend T::Sig
      include Work::WorkRepository

      sig {override.params(pbi_id: Pbi::Id).returns(Work::Work)}
      def find_by_pbi_id(pbi_id)
        Dao::Work.find_by!(dao_pbi_id: pbi_id.to_s).read
      rescue ActiveRecord::RecordNotFound
        raise Work::NotFound
      end

      sig {override.params(work: Work::Work).void}
      def store(work)
        Dao::Work.find_or_initialize_by(dao_pbi_id: work.pbi_id.to_s).tap do |dao|
          dao.write(work)
          dao.save!
        end
      end
    end
  end
end
