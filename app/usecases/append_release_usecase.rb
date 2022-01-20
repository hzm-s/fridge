# typed: strict
require 'sorbet-runtime'

class AppendReleaseUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(RoadmapRepository::AR, Roadmap::RoadmapRepository)
  end

  sig {params(roles: Team::RoleSet, product_id: Product::Id, title: T.nilable(Shared::Name)).void}
  def perform(roles, product_id, title = nil)
    roadmap = @repository.find_by_product_id(product_id)
    roadmap.append_release(roles, title)
    @repository.store(roadmap)
  end
end
