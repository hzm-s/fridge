# typed: strict
require 'sorbet-runtime'

module Sprint
  class RevertPbi
    extend T::Sig

    sig {params(sprint_repository: SprintRepository, pbi_repository: Pbi::PbiRepository).void}
    def initialize(sprint_repository, pbi_repository)
      @sprint_repository = sprint_repository
      @pbi_repository = pbi_repository
    end

    sig {params(roles: Team::RoleSet, sprint: T.nilable(Sprint), pbi: Pbi::Pbi).void}
    def revert(roles, sprint, pbi)
      raise NotStarted unless sprint

      pbi.revert_from_sprint(roles)

      sprint.items.remove(pbi.id)
        .then { |items| sprint.update_items(roles, items) }

      @sprint_repository.store(sprint)
      @pbi_repository.store(pbi)
    end
  end
end
