# typed: strict
require 'sorbet-runtime'

class ChangeReleaseTitleUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(ReleaseRepository::AR, Release::ReleaseRepository)
  end

  sig {params(id: Release::Id, title: String).void}
  def perform(id, title)
    release = @repository.find_by_id(id)
    release.change_title(title)
    @repository.update(release)
  end
end
