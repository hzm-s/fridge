# typed: strict
require 'sorbet-runtime'

class AddReleaseUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(ReleaseRepository::AR, Release::ReleaseRepository)
  end

  sig {params(product_id: Product::Id, title: String).returns(Release::Id)}
  def perform(product_id, title)
    release = Release::Release.create(product_id, title)
    @repository.store(release)
    release.id
  end
end
