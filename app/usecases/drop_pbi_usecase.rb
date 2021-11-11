# typed: strict
require 'sorbet-runtime'

class DropPbiUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @pbi_repository = T.let(PbiRepository::AR, Pbi::PbiRepository)
    @plan_repository = T.let(PlanRepository::AR, Plan::PlanRepository)
  end

  sig {params(product_id: Product::Id, roles: Team::RoleSet, pbi_id: Pbi::Id).void}
  def perform(product_id, roles, pbi_id)
    transaction do
      Plan::DropPbi.new(@pbi_repository, @plan_repository)
        .drop(product_id, roles, pbi_id)
    end
  end
end
