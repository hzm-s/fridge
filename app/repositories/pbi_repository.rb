# typed: strict
require 'sorbet-runtime'

module PbiRepository
  module AR
    class << self
      extend T::Sig
      include Pbi::PbiRepository

      sig {override.params(id: Pbi::Id).returns(Pbi::Pbi)}
      def find_by_id(id)
        r = Dao::Pbi.eager_load(:criteria).find(id)
        Pbi::Pbi.from_repository(
          r.feature_id_as_do,
          r.product_id_as_do,
          r.status_as_do,
          r.description_as_do,
          r.story_point_as_do,
          r.acceptance_criteria_as_do
        )
      end

      sig {override.params(feature: Pbi::Pbi).void}
      def add(feature)
        Dao::Pbi.create!(
          id: feature.id.to_s,
          dao_product_id: feature.product_id.to_s,
          status: feature.status.to_s,
          description: feature.description.to_s,
          size: feature.size.to_i,
        )
      end

      sig {override.params(feature: Pbi::Pbi).void}
      def update(feature)
        r = Dao::Pbi.find(feature.id.to_s)
        r.status = feature.status.to_s
        r.description = feature.description.to_s
        r.size = feature.size.to_i

        r.criteria.clear
        feature.acceptance_criteria.to_a.each do |ac|
          r.criteria.build(content: ac.to_s)
        end

        r.save!
      end

      sig {override.params(id: Pbi::Id).void}
      def delete(id)
        Dao::Pbi.destroy(id.to_s)
      end
    end
  end
end
