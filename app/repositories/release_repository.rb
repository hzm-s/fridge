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
          title: release.title
        )
        dao.items = build_items(release.items.to_a)
        dao.save!
      end

      sig {override.params(release: Release::Release).void}
      def update(release)
        dao = Dao::Release.find(release.id)
        dao.title = release.title
        dao.items = build_items(release.items.to_a)
        dao.save!
      end

      private

      sig {params(items: Release::ItemList::Items).returns(T::Array[Dao::ReleaseItem])}
      def build_items(items)
        items.map do |item|
          Dao::ReleaseItem.new(dao_pbi_id: item)
        end
      end
    end
  end
end
