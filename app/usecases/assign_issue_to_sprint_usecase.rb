# typed: strict
require 'sorbet-runtime'

class AssignIssueToSprintUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @sprint_repository = T.let(SprintRepository::AR, Sprint::SprintRepository)
    @issue_repository = T.let(IssueRepository::AR, Issue::IssueRepository)
    @work_repository = T.let(WorkRepository::AR, Work::WorkRepository)
  end

  sig {params(product_id: Product::Id, roles: Team::RoleSet, issue_id: Issue::Id).void}
  def perform(product_id, roles, issue_id)
    issue = @issue_repository.find_by_id(issue_id)
    sprint = @sprint_repository.current(product_id)

    transaction do
      Sprint::AssignIssue
        .new(@sprint_repository, @issue_repository, @work_repository)
        .assign(roles, sprint, issue)
    end
  end
end
