# typed: strict
require 'sorbet-runtime'

module ReleaseRepository
  module AR
    class << self
      extend T::Sig
      include Release::ReleaseRepository

      sig {override.params(id: Release::Id).returns(Release::Release)}
      def find_by_id(id)
        r = Dao::Release.find(id.to_s)

        Release::Release.from_repository(
          Release::Id.from_string(r.id),
          Product::Id.from_string(r.dao_product_id),
          r.title,
          r.items.map { |i| Pbi::Id.from_string(i) }
        )
      end

      sig {override.params(release: Release::Release).void}
      def add(release)
        r = Dao::Release.new(
          id: release.id.to_s,
          dao_product_id: release.product_id.to_s,
          title: release.title,
        )
        r.items = release.items.map(&:to_s)
        r.save!
      end

      sig {override.params(release: Release::Release).void}
      def update(release)
        r = Dao::Release.find(release.id.to_s)
        r.title = release.title
        r.items = release.items.map(&:to_s)
        r.save!
      end
    end
  end
end
