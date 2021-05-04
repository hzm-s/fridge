# typed: strict
require 'sorbet-runtime'

class AssignIssueToSprintUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @issue_repository = T.let(IssueRepository::AR, Issue::IssueRepository)
    @sprint_repository = T.let(SprintRepository::AR, Sprint::SprintRepository)
  end

  sig {params(product_id: Product::Id, roles: Team::RoleSet, issue_id: Issue::Id).void}
  def perform(product_id, roles, issue_id)
    issue = @issue_repository.find_by_id(issue_id)
    sprint = @sprint_repository.current(product_id)
    issue.assign_to_sprint(roles)
    @issue_repository.store(issue)
  end
end
