# typed: strict
require 'sorbet-runtime'

class SatisfyAcceptanceCriterionUsecase < UsecaseBase
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
      criterion.satisfy
      criteria.update(criterion)
      issue.update_acceptance_criteria(criteria)
    end

    @repository.store(issue)
  end
end