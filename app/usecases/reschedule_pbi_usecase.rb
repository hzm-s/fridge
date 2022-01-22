# typed: strict
require 'sorbet-runtime'

class ReschedulePbiUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(RoadmapRepository::AR, Roadmap::RoadmapRepository)
  end

  sig {params(product_id: Product::Id, roles: Team::RoleSet, from: Pbi::Id, release_number: Integer, to: T.nilable(Pbi::Id)).void}
  def perform(product_id, roles, from, release_number, to)
    new_roadmap =
      @repository.find_by_product_id(product_id)
        .then { |roadmap| [roadmap, Roadmap::ChangeRoadmap.new(roles)] }
        .then { |roadmap, c| c.reschedule(roadmap, from, release_number, to) }

    @repository.store(new_roadmap)
  end
end
