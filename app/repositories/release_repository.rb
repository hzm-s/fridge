# typed: true
require 'sorbet-runtime'

module ReleaseRepository
  class AR < Dao::Release
    class << self
      extend T::Sig
      include Release::ReleaseRepository

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
  end
end
