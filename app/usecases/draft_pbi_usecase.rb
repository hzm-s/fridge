# typed: strict
require 'sorbet-runtime'

class DraftPbiUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @pbi_repository = T.let(PbiRepository::AR, Pbi::PbiRepository)
    @roadmap_repository = T.let(RoadmapRepository::AR, Roadmap::RoadmapRepository)
    @roles = Team::RoleSet.new([Team::Role::ProductOwner])
  end

  sig {params(product_id: Product::Id, type: Pbi::Types, description: Shared::LongSentence, release_number: T.nilable(Integer)).returns(Pbi::Id)}
  def perform(product_id, type, description, release_number = nil)
    pbi = Pbi::Pbi.draft(product_id, type, description)

    roadmap = @roadmap_repository.find_by_product_id(product_id)

    detect_release(roadmap, release_number)
      .then { |release| release.plan_item(pbi.id) }
      .then { |release| roadmap.update_release(@roles, release) }

    @pbi_repository.store(pbi)
    @roadmap_repository.store(roadmap)

    pbi.id
  end

  private

  sig {params(roadmap: Roadmap::Roadmap, release_number: T.nilable(Integer)).returns(Roadmap::Release)}
  def detect_release(roadmap, release_number = nil)
    return roadmap.recent_release unless release_number

    roadmap.release_of(release_number)
  end
end
