# typed: strict
require 'sorbet-runtime'

class ModifyIssueUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(IssueRepository::AR, Issue::IssueRepository)
  end

  sig {params(issue_id: Issue::Id, description: Issue::Description).void}
  def perform(issue_id, description)
    issue = @repository.find_by_id(issue_id)
    issue.modify_description(description)
    @repository.store(issue)
  end
end
