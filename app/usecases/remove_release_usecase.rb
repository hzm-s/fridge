# typed: strict
require 'sorbet-runtime'

class RemoveReleaseUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(RoadmapRepository::AR, Roadmap::RoadmapRepository)
  end

  sig {params(product_id: Product::Id, roles: Team::RoleSet, release_number: Integer).void}
  def perform(product_id, roles, release_number)
    roadmap = @repository.find_by_product_id(product_id)

    roadmap.remove_release(roles, release_number)

    @repository.store(roadmap)
  end
end
