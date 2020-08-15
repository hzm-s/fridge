# typed: false
class PlansController < ApplicationController
  def update
    product_id = Product::Id.from_string(params[:product_id])
    plan = ReleaseRepository::AR.find_plan_by_product_id(product_id)

    from = plan.find { |release| release.id.to_s == params[:from_id] }
    to = plan.find { |release| release.id.to_s == params[:to_id] }
    item_id = Pbi::Id.from_string(params[:item_id])
    position = params[:position].to_i

    SortProductBacklogUsecase.perform(from.id, item_id, to.id, position)
  end
end
