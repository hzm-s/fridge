# typed: strict
require 'sorbet-runtime'

class SwapReleaseItemPrioritiesUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(ReleaseRepository::AR, Release::ReleaseRepository)
  end

  sig {params(release_id: Release::Id, item: Issue::Id, new_index: Integer).void}
  def perform(release_id, item, new_index)
    release = @repository.find_by_id(release_id)
    to = release.fetch_item(new_index)
    release.swap_priorities(item, to)
    @repository.store(release)
  end
end
