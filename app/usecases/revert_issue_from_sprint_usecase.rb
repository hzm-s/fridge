# typed: strict
require 'sorbet-runtime'

class RevertIssueFromSprintUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @sprint_repository = T.let(SprintRepository::AR, Sprint::SprintRepository)
    @issue_repository = T.let(IssueRepository::AR, Issue::IssueRepository)
  end

  sig {params(product_id: Product::Id, roles: Team::RoleSet, issue_id: Issue::Id).void}
  def perform(product_id, roles, issue_id)
    issue = @issue_repository.find_by_id(issue_id)
    sprint = @sprint_repository.current(product_id)

    transaction do
      Sprint::RevertIssue.new(@sprint_repository, @issue_repository)
        .revert(roles, sprint, issue)
    end
  end
end
