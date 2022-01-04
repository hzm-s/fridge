# typed: strict
require 'sorbet-runtime'

class RevertPbiFromSprintUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @sprint_repository = T.let(SprintRepository::AR, Sprint::SprintRepository)
    @pbi_repository = T.let(PbiRepository::AR, Pbi::PbiRepository)
    @work_repository = T.let(WorkRepository::AR, Work::WorkRepository)
  end

  sig {params(product_id: Product::Id, roles: Team::RoleSet, pbi_id: Pbi::Id).void}
  def perform(product_id, roles, pbi_id)
    pbi = @pbi_repository.find_by_id(pbi_id)
    sprint = @sprint_repository.current(product_id)

    transaction do
      Sprint::RevertPbi.new(@sprint_repository, @pbi_repository)
        .revert(roles, sprint, pbi)
    end
  end
end
