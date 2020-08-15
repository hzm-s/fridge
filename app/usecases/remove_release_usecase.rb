# typed: strict
require 'sorbet-runtime'

class RemoveReleaseUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(ReleaseRepository::AR, Release::ReleaseRepository)
  end

  sig {params(id: Release::Id).void}
  def perform(id)
    release = @repository.find_by_id(id)
    raise Release::CanNotRemoveRelease unless release.can_remove? 

    @repository.remove(id)
  end
end
