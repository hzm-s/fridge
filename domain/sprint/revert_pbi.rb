# typed: strict
require 'sorbet-runtime'

module Sprint
  class RevertPbi
    extend T::Sig

    sig {params(sprint_repository: SprintRepository, pbi_repository: Pbi::PbiRepository, sbi_repository: Sbi::SbiRepository).void}
    def initialize(sprint_repository, pbi_repository, sbi_repository)
      @sprint_repository = sprint_repository
      @pbi_repository = pbi_repository
      @sbi_repository = sbi_repository
    end

    sig {params(roles: Team::RoleSet, sprint: T.nilable(Sprint), pbi: Pbi::Pbi, sbi: Sbi::Sbi).void}
    def revert(roles, sprint, pbi, sbi)
      raise NotStarted unless sprint

      pbi.revert_from_sprint(roles)

      sprint.items.remove(sbi.id)
        .then { |items| sprint.update_items(roles, items) }

      @sbi_repository.remove(sbi.id)
      @sprint_repository.store(sprint)
      @pbi_repository.store(pbi)
    end
  end
end
