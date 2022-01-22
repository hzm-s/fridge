# typed: strict
require 'sorbet-runtime'

module RoadmapRepository
  class AR
    class << self
      extend T::Sig
      include Roadmap::RoadmapRepository

      sig {override.params(product_id: Product::Id).returns(Roadmap::Roadmap)}
      def find_by_product_id(product_id)
        daos = Dao::Release.where(dao_product_id: product_id.to_s).order(:number)
        Dao::Release.read(daos)
      end

      sig {override.params(roadmap: Roadmap::Roadmap).void}
      def store(roadmap)
        roadmap.releases.each do |r|
          dao = Dao::Release.find_or_initialize_by(dao_product_id: roadmap.product_id.to_s, number: r.number)
          dao.write(r)
          dao.save!
        end
        Dao::Release.sync(roadmap.product_id.to_s, roadmap.releases.map(&:number))
      end
    end
  end
end
