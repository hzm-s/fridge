# typed: strict
require 'sorbet-runtime'

class EstimateFeatureUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(IssueRepository::AR, Issue::IssueRepository)
  end

  sig {params(id: Issue::Id, point: Issue::StoryPoint).returns(Issue::Id)}
  def perform(id, point)
    feature = @repository.find_by_id(id)
    feature.estimate(point)

    @repository.store(feature)

    feature.id
  end
end
