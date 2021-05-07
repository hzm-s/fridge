# typed: strict
require 'sorbet-runtime'

module Sprint
  class AssignIssue
    extend T::Sig

    sig {params(sprint_repository: SprintRepository, issue_repository: Issue::IssueRepository).void}
    def initialize(sprint_repository, issue_repository)
      @sprint_repository = sprint_repository
      @issue_repository = issue_repository
    end

    sig {params(roles: Team::RoleSet, sprint: Sprint, issue: Issue::Issue).void}
    def assign(roles, sprint, issue)
      issue.assign_to_sprint(roles)
      sprint.append_issue(issue.id)

      @issue_repository.store(issue)
      @sprint_repository.store(sprint)
    end
  end
end
