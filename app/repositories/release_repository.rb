# typed: true
require 'sorbet-runtime'

module ReleaseRepository
  class AR < Dao::Release
    class << self
      extend T::Sig
      include Release::ReleaseRepository

      sig {override.params(id: Release::Id).returns(Release::Release)}
      def find_by_id(id)
        eager_load(:items).find(id).read
      end

      sig {override.params(release: Release::Release).void}
      def store(release)
        find_or_initialize_by(id: release.id.to_s).tap do |dao|
          dao.write(release)
          dao.save!
        end
      end
    end

    def write(release)
      self.attributes = {
        dao_product_id: release.product_id.to_s,
        title: release.title
      }

      self.items.clear
      release.items.to_a.each do |item|
        self.items.build(dao_issue_id: item)
      end
    end

    def read
      Release::Release.from_repository(
        read_release_id,
        read_product_id,
        title,
        read_items
      )
    end

    def read_release_id
      Release::Id.from_string(id)
    end

    def read_product_id
      Product::Id.from_string(dao_product_id)
    end

    def read_items
      items.map { |item| Issue::Id.from_string(item.dao_issue_id) }
        .yield_self { |list| Release::ItemList.new(list) }
    end
  end
end
