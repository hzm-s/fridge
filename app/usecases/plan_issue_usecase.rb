# typed: strict
require 'sorbet-runtime'

class PlanIssueUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @issue_repository = T.let(IssueRepository::AR, Issue::IssueRepository)
    @plan_repository = T.let(PlanRepository::AR, Plan::PlanRepository)
  end

  sig {params(product_id: Product::Id, type: Issue::Type, description: Issue::Description, release_number: T.nilable(Integer)).returns(Issue::Id)}
  def perform(product_id, type, description, release_number = nil)
    issue = Issue::Issue.create(product_id, type, description)

    transaction do
      Plan::AppendIssue.new(@issue_repository, @plan_repository)
        .append(product_id, issue, release_number)
    end

    issue.id
  end
end
