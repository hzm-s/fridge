# typed: strict
require 'sorbet-runtime'

class RemoveAcceptanceCriterionUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(IssueRepository::AR, Issue::IssueRepository)
  end

  sig {params(issue_id: Issue::Id, number: Integer).void}
  def perform(issue_id, number)
    issue = @repository.find_by_id(issue_id)

    criteria = issue.acceptance_criteria
    criteria.remove(number)
    issue.update_acceptance_criteria(criteria)

    @repository.store(issue)
  end
end
