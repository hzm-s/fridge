# typed: ignore
class SbisController < ApplicationController
  include ProductHelper
  include TeamMemberHelper

  before_action :require_user

  def create
    pbi_id = Pbi::Id.from_string(params[:pbi_id])
    AssignPbiToSprintUsecase.perform(
      Product::Id.from_string(current_product_id),
      current_team_member_roles,
      pbi_id,
    )
  rescue Sprint::NotStarted => e
    redirect_to sprint_backlog_path(product_id: current_product_id), flash: flash_success('sprint.not_started')
  else
    flash.now[:success] = feedback_message('pbi.assign_to_sprint')
    @pbi = PbiQuery.call(pbi_id)
  end

  def destroy
    RevertPbiFromSprintUsecase.perform(
      Product::Id.from_string(current_product_id),
      current_team_member_roles,
      Pbi::Id.from_string(params[:pbi_id]),
    )
    redirect_to sprint_backlog_path(product_id: current_product_id), flash: flash_success('pbi.revert_from_sprint')
  end

  private

  def current_product_id
    params[:product_id]
  end
end
