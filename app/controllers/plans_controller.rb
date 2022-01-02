# typed: ignore
class PlansController < ApplicationController
  include ProductHelper
  include TeamMemberHelper

  before_action :require_user

  def update
    product_id = Product::Id.from_string(current_product_id)
    roles = current_team_member_roles

    from = {
      item_id: Pbi::Id.from_string(params[:item_id]),
      release_number: params[:from].to_i
    }
    to = {
      item_id: PlannedPbiQuery.call(product_id.to_s, params[:to].to_i, params[:to_index].to_i),
      release_number: params[:to].to_i
    }

    if from[:release_number] == to[:release_number]
      ChangePbiPriorityUsecase.perform(product_id, roles, from[:item_id], to[:item_id])
    else
      ReschedulePbiUsecase.perform(product_id, roles, from[:item_id], to[:release_number], to[:item_id])
    end
  end

  private

  def current_product_id
    params[:product_id]
  end
end
