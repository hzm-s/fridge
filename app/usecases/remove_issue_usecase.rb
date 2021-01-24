# typed: strict
require 'sorbet-runtime'

class RemoveIssueUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(IssueRepository::AR, Issue::IssueRepository)
  end

  sig {params(roles: Team::RoleSet, issue_id: Issue::Id).void}
  def perform(roles, issue_id)
    issue = @repository.find_by_id(issue_id)
    transaction do
      RemoveIssueFromPlanUsecase.perform(issue.product_id, roles, issue.id)
      @repository.remove(issue.id)
    end
  end
end
