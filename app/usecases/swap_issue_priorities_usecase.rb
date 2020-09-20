# typed: strict
require 'sorbet-runtime'

class SwapIssuePrioritiesUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(ReleaseRepository::AR, Release::ReleaseRepository)
  end

  sig {params(item: Issue::Id, release_id: Release::Id, new_index: Integer).void}
  def perform(item, release_id, new_index)
    release = @repository.find_by_id(release_id)
    release.swap_priorities(item, release.fetch_item(new_index))
    @repository.store(release)
  end
end
