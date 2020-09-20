# typed: strict
require 'sorbet-runtime'

class PlanIssueReleaseUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(ReleaseRepository::AR, Release::ReleaseRepository)
  end

  sig {params(item: Issue::Id, release_id: Release::Id, new_index: Integer).void}
  def perform(item, release_id, new_index)
    to = @repository.find_by_id(release_id)
    to.add_item(item)
    to.swap_priorities(item, to.fetch_item(new_index))
    @repository.store(to)
  end
end
