# typed: strict
require 'sorbet-runtime'

class RemoveReleaseItemUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(ReleaseRepository::AR, Release::ReleaseRepository)
  end

  sig {params(issue_id: Issue::Id, release_id: Release::Id).void}
  def perform(issue_id, release_id)
    release = @repository.find_by_id(release_id)
    release.remove_item(issue_id)
    @repository.store(release)
  end
end
