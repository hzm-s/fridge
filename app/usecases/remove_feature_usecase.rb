# typed: strict
require 'sorbet-runtime'

class RemoveFeatureUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @feature_repository = T.let(FeatureRepository::AR, Feature::FeatureRepository)
    @pbl_repository = T.let(ProductBacklogRepository::AR, ProductBacklog::ProductBacklogRepository)
  end

  sig {params(feature_id: Feature::Id).void}
  def perform(feature_id)
    feature = @feature_repository.find_by_id(feature_id)
    raise Feature::CanNotRemove unless feature.status.can_remove?

    pbl = @pbl_repository.find_by_product_id(feature.product_id)
    pbl.remove_item(feature.id)

    transaction do
      @feature_repository.delete(feature.id)
      @pbl_repository.update(pbl)
    end
  end
end
