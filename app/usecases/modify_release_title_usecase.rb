# typed: strict
require 'sorbet-runtime'

class ModifyReleaseTitleUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(ReleaseRepository::AR, Release::ReleaseRepository)
  end

  sig {params(release_id: Release::Id, title: String).void}
  def perform(release_id, title)
    release = @repository.find_by_id(release_id)

    release.modify_title(title)

    @repository.store(release)
  end
end
