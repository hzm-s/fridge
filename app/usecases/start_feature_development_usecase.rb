# typed: strict
require 'sorbet-runtime'

class StartFeatureDevelopmentUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(FeatureRepository::AR, Feature::FeatureRepository)
  end

  sig {params(id: Feature::Id).void}
  def perform(id)
    feature = @repository.find_by_id(id)
    feature.start_development
    @repository.update(feature)
  end
end
