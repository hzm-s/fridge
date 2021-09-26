# typed: strict
require 'sorbet-runtime'

module Sprint
  class AssignIssue
    extend T::Sig

    sig {params(
      sprint_repository: SprintRepository,
      issue_repository: Issue::IssueRepository,
      work_repository: Work::WorkRepository,
    ).void}
    def initialize(sprint_repository, issue_repository, work_repository)
      @sprint_repository = sprint_repository
      @issue_repository = issue_repository
      @work_repository = work_repository
    end

    sig {params(roles: Team::RoleSet, sprint: T.nilable(Sprint), issue: Issue::Issue).void}
    def assign(roles, sprint, issue)
      raise NotStarted unless sprint

      issue.assign_to_sprint(roles)
      sprint.update_issues(roles, sprint.issues.append(issue.id))
      work = Work::Work.create(issue)

      @issue_repository.store(issue)
      @sprint_repository.store(sprint)
      @work_repository.store(work)
    end
  end
end
