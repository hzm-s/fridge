# typed: ignore
class CurrentSprint::IssuesController < ApplicationController
  include ProductHelper
  include TeamMemberHelper

  before_action :require_user

  def create
    issue_id = Issue::Id.from_string(params[:issue_id])
    AssignIssueToSprintUsecase.perform(
      Product::Id.from_string(current_product_id),
      current_team_member_roles,
      issue_id,
    )
  rescue Sprint::NotStarted => e
    redirect_to sprint_backlog_path(product_id: current_product_id), flash: flash_success('sprint.not_started')
  else
    flash.now[:success] = feedback_message('issue.assign_to_sprint')
    @issue = IssueQuery.call(issue_id)
  end

  def destroy
    RevertIssueFromSprintUsecase.perform(
      Product::Id.from_string(current_product_id),
      current_team_member_roles,
      Issue::Id.from_string(params[:id]),
    )
    redirect_to sprint_backlog_path(product_id: current_product_id), flash: flash_success('issue.revert_from_sprint')
  end

  private

  def current_product_id
    params[:product_id]
  end
end
