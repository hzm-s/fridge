# typed: strict
require 'sorbet-runtime'

class AppendAcceptanceCriterionUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(IssueRepository::AR, Issue::IssueRepository)
  end

  sig {params(issue_id: Issue::Id, content: String).void}
  def perform(issue_id, content)
    issue = @repository.find_by_id(issue_id)

    criteria = issue.acceptance_criteria
    criteria.append(content)
    issue.update_acceptance_criteria(criteria)

    @repository.store(issue)
  end
end
