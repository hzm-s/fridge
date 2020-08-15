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
        build_release(r)
      end

      sig {override.params(product_id: Product::Id).returns(T::Array[Release::Release])}
      def find_plan_by_product_id(product_id)
        rs = Dao::Release.where(dao_product_id: product_id.to_s)
        rs.map { |r| build_release(r) }
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

      sig {override.params(id: Release::Id).void}
      def remove(id)
        Dao::Release.destroy(id)
      end

      sig {override.params(release: Release::Release).void}
      def save(release)
        update(release)
      rescue ActiveRecord::RecordNotFound
        add(release)
      end

      private

      sig {params(rel: T.untyped).returns(Release::Release)}
      def build_release(rel)
        Release::Release.from_repository(
          Release::Id.from_string(rel.id),
          Product::Id.from_string(rel.dao_product_id),
          rel.title,
          rel.items.map { |i| Pbi::Id.from_string(i) }
        )
      end
    end
  end
end
