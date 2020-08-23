# typed: strict
require 'sorbet-runtime'

class RemoveAcceptanceCriterionUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(FeatureRepository::AR, Feature::FeatureRepository)
  end

  sig {params(feature_id: Feature::Id, criterion: Feature::AcceptanceCriterion).void}
  def perform(feature_id, criterion)
    feature = @repository.find_by_id(feature_id)

    criteria = feature.acceptance_criteria.remove(criterion)
    feature.update_acceptance_criteria(criteria)

    @repository.update(feature)
  end
end
