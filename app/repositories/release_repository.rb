# typed: strict
require 'sorbet-runtime'

module ReleaseRepository
  class AR
    class << self
      extend T::Sig
      include Release::ReleaseRepository

      sig {override.returns(Integer)}
      def next_number
        Dao::Release.maximum(:number).to_i + 1
      end

      sig {override.params(release: Release::Release).void}
      def store(release)
        dao = Dao::Release.find_or_initialize_by(dao_product_id: release.product_id.to_s, number: release.number)
        dao.write(release)
        dao.save!
      end
    end
  end
end
