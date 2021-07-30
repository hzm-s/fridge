# typed: strict
require 'sorbet-runtime'

module Sprint
  class RevertIssue
    extend T::Sig

    sig {params(sprint_repository: SprintRepository, issue_repository: Issue::IssueRepository).void}
    def initialize(sprint_repository, issue_repository)
      @sprint_repository = sprint_repository
      @issue_repository = issue_repository
    end

    sig {params(roles: Team::RoleSet, sprint: T.nilable(Sprint), issue: Issue::Issue).void}
    def revert(roles, sprint, issue)
      raise NotStarted unless sprint
      raise Issue::AlreadyAccepted if issue.status == Issue::Statuses::Accepted

      issue.revert_from_sprint(roles)
      sprint.update_issues(roles, sprint.issues.remove(issue.id))

      @sprint_repository.store(sprint)
      @issue_repository.store(issue)
    end
  end
end
