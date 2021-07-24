# typed: strict
require 'sorbet-runtime'

class DissatisfyAcceptanceCriterionUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(IssueRepository::AR, Issue::IssueRepository)
  end

  sig {params(issue_id: Issue::Id, number: Integer).void}
  def perform(issue_id, number)
    issue = @repository.find_by_id(issue_id)

    issue.acceptance_criteria.tap do |criteria|
      criterion = criteria.of(number)
      criterion.dissatisfy
      criteria.update(criterion)
      issue.prepare_acceptance_criteria(criteria)
    end

    @repository.store(issue)
  end
end
