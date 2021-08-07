class AcceptancesController < ApplicationController
  include ProductHelper
  include TeamMemberHelper

  def show
    @issue = IssueQuery.call(params[:issue_id])
  end

  def update
    AcceptIssueUsecase.perform(
      current_team_member_roles,
      Issue::Id.from_string(params[:issue_id])
    )
  end

  private

  def current_product_id
    IssueQuery.call(params[:issue_id]).product_id
  end
end
