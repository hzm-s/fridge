# typed: ignore
class CurrentSprint::WorkPrioritiesController < ApplicationController
  include ProductHelper
  include TeamMemberHelper

  before_action :require_user

  def update
    product_id = Product::Id.from_string(current_product_id)
    roles = current_team_member_roles
    issue_id = Issue::Id.from_string(params[:issue_id])
    to_index = params[:to_index].to_i
    ChangeWorkPriorityUsecase.perform(product_id, roles, issue_id, to_index)
  end

  private

  def current_product_id
    params[:product_id]
  end
end
