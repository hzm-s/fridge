# typed: strict
require 'sorbet-runtime'

class CancelIssueReleaseUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(ReleaseRepository::AR, Release::ReleaseRepository)
  end

  sig {params(item: Issue::Id, release_id: Release::Id).void}
  def perform(item, release_id)
    release = @repository.find_by_id(release_id)
    release.remove_item(item)
    @repository.store(release)
  end
end
