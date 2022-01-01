# typed: strict
require 'sorbet-runtime'

class DraftPbiUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @pbi_repository = T.let(PbiRepository::AR, Pbi::PbiRepository)
    @plan_repository = T.let(PlanRepository::AR, Plan::PlanRepository)
    @roles = Team::RoleSet.new([Team::Role::ProductOwner])
  end

  sig {params(product_id: Product::Id, type: Pbi::Types, description: Shared::LongSentence, release_number: T.nilable(Integer)).returns(Pbi::Id)}
  def perform(product_id, type, description, release_number = nil)
    pbi = Pbi::Pbi.draft(product_id, type, description)

    plan = @plan_repository.find_by_product_id(product_id)

    detect_release(plan, release_number)
      .then { |release| release.plan_item(pbi.id) }
      .then { |release| plan.update_release(@roles, release) }

    @pbi_repository.store(pbi)
    @plan_repository.store(plan)

    pbi.id
  end

  private

  sig {params(plan: Plan::Plan, release_number: T.nilable(Integer)).returns(Plan::Release)}
  def detect_release(plan, release_number = nil)
    return plan.recent_release unless release_number

    plan.release_of(release_number)
  end
end
