# typed: strict
require 'sorbet-runtime'

class DraftPbiUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @pbi_repository = T.let(PbiRepository::AR, Pbi::PbiRepository)
    @plan_repository = T.let(PlanRepository::AR, Plan::PlanRepository)
  end

  sig {params(product_id: Product::Id, type: Pbi::Types, description: Shared::LongSentence, release_number: T.nilable(Integer)).returns(Pbi::Id)}
  def perform(product_id, type, description, release_number = nil)
    pbi = Pbi::Pbi.draft(product_id, type, description)

    plan = @plan_repository.find_by_product_id(product_id)
    release = detect_release(plan, release_number)

    roles = Team::RoleSet.new([Team::Role::ProductOwner])

    transaction do
      Plan::AppendItem.new(@pbi_repository, @plan_repository)
        .append(roles, plan, release, pbi)
    end

    pbi.id
  end

  private

  sig {params(plan: Plan::Plan, release_number: T.nilable(Integer)).returns(Plan::Release)}
  def detect_release(plan, release_number = nil)
    return plan.recent_release unless release_number

    plan.release_of(release_number)
  end
end
