# typed: ignore
class AcceptancesController < ApplicationController
  include ProductHelper
  include TeamMemberHelper

  before_action :require_user

  def show
    @acceptance = AcceptanceQuery.call(params[:issue_id])
  end

  def update
    AcceptWorkUsecase.perform(
      current_team_member_roles,
      Issue::Id.from_string(params[:issue_id])
    )
    redirect_to sprint_backlog_path(current_product_id), flash: flash_success([:issue, :accept])
  end

  private

  def current_product_id
    @__current_product_id ||= resolve_product_id_by_issue_id(params[:issue_id])
  end
end
