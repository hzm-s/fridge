# typed: strict
require 'sorbet-runtime'

class PlanIssueUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @issue_repository = T.let(IssueRepository::AR, Issue::IssueRepository)
    @plan_repository = T.let(PlanRepository::AR, Plan::PlanRepository)
  end

  sig {params(product_id: Product::Id, type: Issue::Type, description: Shared::LongSentence, release_number: T.nilable(Integer)).returns(Issue::Id)}
  def perform(product_id, type, description, release_number = nil)
    issue = Issue::Issue.create(product_id, type, description)

    plan = @plan_repository.find_by_product_id(product_id)
    release = detect_release(plan, release_number)

    roles = Team::RoleSet.new([Team::Role::ProductOwner])

    transaction do
      Plan::AppendIssue.new(@issue_repository, @plan_repository)
        .append(roles, plan, release, issue)
    end

    issue.id
  end

  private

  sig {params(plan: Plan::Plan, release_number: T.nilable(Integer)).returns(Plan::Release)}
  def detect_release(plan, release_number = nil)
    return plan.recent_release unless release_number

    plan.release_of(release_number)
  end
end
