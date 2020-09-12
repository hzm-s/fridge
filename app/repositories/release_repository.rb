# typed: strict
require 'sorbet-runtime'

module ReleaseRepository
  module AR
    class << self
      extend T::Sig
      include Release::ReleaseRepository

      sig {override.params(release: Release::Release).void}
      def add(release)
        dao = Dao::Release.new(
          id: release.id,
          previous_release_id: release.previous_release_id,
          title: release.title
        )
        dao.items = release.items.to_a.map do |item|
          Dao::ReleaseItem.new(dao_pbi_id: item)
        end
        dao.save!
      end
    end
  end
end
