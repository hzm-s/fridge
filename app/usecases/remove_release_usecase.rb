# typed: strict
require 'sorbet-runtime'

class RemoveReleaseUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(ReleaseRepository::AR, Release::ReleaseRepository)
  end

  sig {params(release_id: Release::Id).void}
  def perform(release_id)
    release = @repository.find_by_id(release_id)
    raise Release::CanNotRemove unless release.can_remove?

    @repository.remove(release.id)
  end
end
