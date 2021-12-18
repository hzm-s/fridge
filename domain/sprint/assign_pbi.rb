# typed: strict
require 'sorbet-runtime'

module Sprint
  class AssignPbi
    extend T::Sig

    sig {params(
      sprint_repository: SprintRepository,
      pbi_repository: Pbi::PbiRepository,
      sbi_repository: Sbi::SbiRepository,
    ).void}
    def initialize(sprint_repository, pbi_repository, sbi_repository)
      @sprint_repository = sprint_repository
      @pbi_repository = pbi_repository
      @sbi_repository = sbi_repository
    end

    sig {params(roles: Team::RoleSet, sprint: T.nilable(Sprint), pbi: Pbi::Pbi).void}
    def assign(roles, sprint, pbi)
      raise NotStarted unless sprint

      sprint.update_items(roles, sprint.items.append(pbi.id))
      pbi.assign_to_sprint(roles)
      sbi = Sbi::Sbi.plan(pbi.id)

      @pbi_repository.store(pbi)
      @sprint_repository.store(sprint)
      @sbi_repository.store(sbi)
    end
  end
end
