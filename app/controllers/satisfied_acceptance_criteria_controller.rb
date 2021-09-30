# typed: ignore
class SatisfiedAcceptanceCriteriaController < ApplicationController
  include ProductHelper
  include TeamMemberHelper

  before_action :require_user

  def create
    issue_id = Issue::Id.from_string(params[:issue_id])
    number = params[:number].to_i
    SatisfyAcceptanceCriterionUsecase.perform(current_team_member_roles, issue_id, number)

    redirect_to issue_acceptance_path(issue_id: issue_id.to_s)
  end

  def destroy
    issue_id = Issue::Id.from_string(params[:issue_id])
    number = params[:number].to_i
    DissatisfyAcceptanceCriterionUsecase.perform(current_team_member_roles, issue_id, number)

    redirect_to issue_acceptance_path(issue_id: issue_id.to_s)
  end

  private

  def current_product_id
    resolve_product_id_by_issue_id(params[:issue_id])
  end
end
