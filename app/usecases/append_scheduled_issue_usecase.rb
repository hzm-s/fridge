# typed: strict
require 'sorbet-runtime'

class AppendScheduledIssueUsecase < UsecaseBase
  extend T::Sig

  sig {
    params(
      product_id: Product::Id,
      roles: Team::RoleSet,
      issue_type: Issue::Type,
      description: Issue::Description,
      release_name: String
    ).returns(Issue::Id)
  }
  def perform(product_id, roles, issue_type, description, release_name)
    transaction do
      issue_id = AppendIssueUsecase.perform(product_id, issue_type, description)
      ScheduleIssueUsecase.perform(product_id, roles, issue_id, release_name, -1)
    end
  end
end
