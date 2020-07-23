# typed: false
class ProductBacklogOrdersController < ApplicationController
  def update
    product_id = Product::Id.from_string(params[:product_id])
    pbi_id = Pbi::Id.from_string(params[:pbi_id])
    to = params[:to].to_i
    ReorderProductBacklogUsecase.perform(product_id, pbi_id, to)
  end
end
