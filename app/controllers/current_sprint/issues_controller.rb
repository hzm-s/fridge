class CurrentSprint::IssuesController < ApplicationController
  include TeamMemberHelper

  def create
    issue_id = Issue::Id.from_string(params[:issue_id])
    AssignIssueToSprintUsecase.perform(
      Product::Id.from_string(current_product_id),
      current_team_member_roles,
      issue_id
    )
    @issue = IssueQuery.call(issue_id)
  end

  private

  def current_product_id
    params[:product_id]
  end
end
