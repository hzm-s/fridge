# typed: false
class PlansController < ApplicationController
  def update
    product_id = Product::Id.from_string(params[:product_id])
    item_id = Pbi::Id.from_string(params[:item_id])
    position = params[:position].to_i
    SortProductBacklogUsecase.perform(product_id, item_id, position)
  end
end
