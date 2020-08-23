# typed: strict
require 'sorbet-runtime'

class ModifyFeatureUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(FeatureRepository::AR, Feature::FeatureRepository)
  end

  sig {params(feature_id: Feature::Id, description: Feature::Description).void}
  def perform(feature_id, description)
    feature = @repository.find_by_id(feature_id)
    feature.modify_description(description)
    @repository.update(feature)
  end
end
