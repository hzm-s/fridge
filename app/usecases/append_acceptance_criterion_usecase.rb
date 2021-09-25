# typed: strict
require 'sorbet-runtime'

class AppendAcceptanceCriterionUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(IssueRepository::AR, Issue::IssueRepository)
  end

  sig {params(issue_id: Issue::Id, content: Shared::ShortSentence).void}
  def perform(issue_id, content)
    issue = @repository.find_by_id(issue_id)

    issue.acceptance_criteria
      .then { |c| c.append(content) }
      .then { |c| issue.prepare_acceptance_criteria(c) }

    @repository.store(issue)
  end
end
