# typed: strict
require 'sorbet-runtime'

class EstimateFeatureUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(FeatureRepository::AR, Feature::FeatureRepository)
  end

  sig {params(id: Feature::Id, point: Feature::StoryPoint).returns(Feature::Id)}
  def perform(id, point)
    feature = @repository.find_by_id(id)
    feature.estimate(point)

    @repository.update(feature)

    feature.id
  end
end
