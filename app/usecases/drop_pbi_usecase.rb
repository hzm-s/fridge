# typed: strict
require 'sorbet-runtime'

class DropPbiUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @pbi_repository = T.let(PbiRepository::AR, Pbi::PbiRepository)
    @roadmap_repository = T.let(RoadmapRepository::AR, Roadmap::RoadmapRepository)
  end

  sig {params(product_id: Product::Id, roles: Team::RoleSet, pbi_id: Pbi::Id).void}
  def perform(product_id, roles, pbi_id)
    roadmap = @roadmap_repository.find_by_product_id(product_id)

    roadmap.release_by_item(pbi_id)
      .then { |release| release.drop_item(pbi_id) }
      .then { |release| roadmap.update_release(roles, release) }

    @roadmap_repository.store(roadmap)
    @pbi_repository.remove(pbi_id)
  end
end
