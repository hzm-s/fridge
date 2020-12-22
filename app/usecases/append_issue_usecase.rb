# typed: strict
require 'sorbet-runtime'

class AppendIssueUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(IssueRepository::AR, Issue::IssueRepository)
  end

  sig {params(product_id: Product::Id, type: Issue::Type, description: Issue::Description).returns(Issue::Id)}
  def perform(product_id, type, description)
    issue = Issue::Issue.create(product_id, type, description)

    transaction do
      @repository.store(issue)
      PlanIssueUsecase.perform(product_id, issue.id)
    end

    issue.id
  end
end
