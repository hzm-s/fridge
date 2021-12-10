# typed: strict
require 'sorbet-runtime'

class RevertPbiFromSprintUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @sprint_repository = T.let(SprintRepository::AR, Sprint::SprintRepository)
    @pbi_repository = T.let(PbiRepository::AR, Pbi::PbiRepository)
    @sbi_repository = T.let(SbiRepository::AR, Sbi::SbiRepository)
  end

  sig {params(product_id: Product::Id, roles: Team::RoleSet, sbi_id: Sbi::Id).void}
  def perform(product_id, roles, sbi_id)
    sbi = @sbi_repository.find_by_id(sbi_id)
    pbi = @pbi_repository.find_by_id(sbi.pbi_id)
    sprint = @sprint_repository.current(product_id)

    transaction do
      Sprint::RevertPbi.new(@sprint_repository, @pbi_repository, @sbi_repository)
        .revert(roles, sprint, pbi, sbi)
    end
  end
end
