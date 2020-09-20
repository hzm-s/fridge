# typed: strict
require 'sorbet-runtime'

module ReleaseRepository
  class AR
    class << self
      extend T::Sig
      include Release::ReleaseRepository

      sig {override.params(id: Release::Id).returns(Release::Release)}
      def find_by_id(id)
        Dao::Release.eager_load(:items).find(id).read
      end

      sig {override.params(release: Release::Release).void}
      def store(release)
        Dao::Release.find_or_initialize_by(id: release.id.to_s).tap do |dao|
          dao.write(release)
          dao.save!
        end
      end

      sig {override.params(id: Release::Id).void}
      def remove(id)
        Dao::Release.find(id).destroy!
      rescue ActiveRecord::InvalidForeignKey
        raise Release::CanNotRemove
      end
    end
  end
end
