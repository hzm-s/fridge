# typed: strict
require 'sorbet-runtime'

class AddAcceptanceCriterionUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(IssueRepository::AR, Issue::IssueRepository)
  end

  sig {params(issue_id: Issue::Id, criterion: Issue::AcceptanceCriterion).void}
  def perform(issue_id, criterion)
    issue = @repository.find_by_id(issue_id)

    criteria = issue.acceptance_criteria.append(criterion)
    issue.update_acceptance_criteria(criteria)

    @repository.store(issue)
  end
end
