# typed: strict
require 'sorbet-runtime'

class AssignPbiToSprintUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @sprint_repository = T.let(SprintRepository::AR, Sprint::SprintRepository)
    @pbi_repository = T.let(PbiRepository::AR, Pbi::PbiRepository)
  end

  sig {params(product_id: Product::Id, roles: Team::RoleSet, pbi_id: Pbi::Id).void}
  def perform(product_id, roles, pbi_id)
    sprint = @sprint_repository.current(product_id)
    raise Sprint::NotStarted unless sprint

    pbi = @pbi_repository.find_by_id(pbi_id)

    sprint.update_items(roles, sprint.items.append(pbi.id))
    pbi.assign_to_sprint(roles)

    @sprint_repository.store(sprint)
    @pbi_repository.store(pbi)
  end
end
