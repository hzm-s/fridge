# typed: strict
require 'sorbet-runtime'

class DropIssueUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @issue_repository = T.let(IssueRepository::AR, Issue::IssueRepository)
    @plan_repository = T.let(PlanRepository::AR, Plan::PlanRepository)
  end

  sig {params(product_id: Product::Id, roles: Team::RoleSet, issue_id: Issue::Id).void}
  def perform(product_id, roles, issue_id)
    transaction do
      Plan::DropIssue.new(@issue_repository, @plan_repository)
        .drop(product_id, roles, issue_id)
    end
  end
end
