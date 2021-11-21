# typed: ignore
class PlansController < ApplicationController
  include ProductHelper
  include TeamMemberHelper

  before_action :require_user

  def update
    product_id = Product::Id.from_string(current_product_id)
    roles = current_team_member_roles
    pbi_id = Pbi::Id.from_string(params[:item_id])
    to_index = params[:to_index].to_i
    to = params[:to].to_i
    from = params[:from].to_i

    if from == to
      ChangePbiPriorityUsecase.perform(product_id, roles, pbi_id, to_index)
    else
      ReschedulePbiUsecase.perform(product_id, roles, pbi_id, to, to_index)
    end
  end

  private

  def current_product_id
    params[:product_id]
  end
end
