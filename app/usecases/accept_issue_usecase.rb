# typed: strict
require 'sorbet-runtime'

class AcceptIssueUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(IssueRepository::AR, Issue::IssueRepository)
  end

  sig {params(roles: Team::RoleSet, issue_id: Issue::Id).void}
  def perform(roles, issue_id)
    issue = @repository.find_by_id(issue_id)
    issue.accept(roles)
    @repository.store(issue)
  end
end
