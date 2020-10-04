# typed: strict
require 'sorbet-runtime'

class RemoveIssueUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(IssueRepository::AR, Issue::IssueRepository)
  end

  sig {params(issue_id: Issue::Id).void}
  def perform(issue_id)
    issue = @repository.find_by_id(issue_id)
    RemoveIssueFromOrderUsecase.perform(issue.product_id, issue.id)
    @repository.delete(issue.id)
  end
end
