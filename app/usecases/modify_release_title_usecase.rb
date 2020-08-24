# typed: strict
require 'sorbet-runtime'

class ModifyReleaseTitleUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(ReleaseRepository::AR, Release::ReleaseRepository)
  end

  sig {params(id: Release::Id, title: String).void}
  def perform(id, title)
    release = @repository.find_by_id(id)
    release.modify_title(title)
    @repository.update(release)
  end
end
