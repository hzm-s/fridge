# typed: false
class PlansController < ApplicationController
  def update
    product_id = Product::Id.from_string(params[:product_id])
    from_no = params[:from_no].to_i
    to_no = params[:to_no].to_i
    item = Pbi::Id.from_string(params[:item])
    position = params[:position].to_i

    SortProductBacklogUsecase.perform(product_id, from_no, item, to_no, position)
  end
end
