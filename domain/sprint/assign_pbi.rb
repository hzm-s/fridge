# typed: strict
require 'sorbet-runtime'

module Sprint
  class AssignPbi
    extend T::Sig

    sig {params(
      sprint_repository: SprintRepository,
      pbi_repository: Pbi::PbiRepository,
    ).void}
    def initialize(sprint_repository, pbi_repository)
      @sprint_repository = sprint_repository
      @pbi_repository = pbi_repository
    end

    sig {params(roles: Team::RoleSet, sprint: T.nilable(Sprint), pbi: Pbi::Pbi).void}
    def assign(roles, sprint, pbi)
      raise NotStarted unless sprint

      sprint.update_items(roles, sprint.items.append(pbi.id))
      pbi.assign_to_sprint(roles)

      @pbi_repository.store(pbi)
      @sprint_repository.store(sprint)
    end
  end
end
