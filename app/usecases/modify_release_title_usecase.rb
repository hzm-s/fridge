# typed: strict
require 'sorbet-runtime'

class ModifyReleaseTitleUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(RoadmapRepository::AR, Roadmap::RoadmapRepository)
  end

  sig {params(product_id: Product::Id, roles: Team::RoleSet, release_number: Integer, title: Shared::Name).void}
  def perform(product_id, roles, release_number, title)
    roadmap = @repository.find_by_product_id(product_id)

    roadmap.release_of(release_number).modify_title(title)
      .then { |release| roadmap.update_release(roles, release) }

    @repository.store(roadmap)
  end
end
