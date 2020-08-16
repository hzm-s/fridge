# typed: false
class PlansController < ApplicationController
  def update
    product_id = Product::Id.from_string(params[:product_id])
    from_id = Release::Id.from_string(params[:from_id])
    to_id = Release::Id.from_string(params[:to_id])
    item_id = Pbi::Id.from_string(params[:item_id])
    position = params[:position].to_i

    SortProductBacklogUsecase.perform(product_id, from_id, item_id, to_id, position)
  end
end
