class ProductBacklogOrdersController < ApplicationController
  def update
    product_id = Product::ProductId.from_string(params[:product_id])
    pbi_id = Pbi::ItemId.from_string(params[:pbi_id])
    to = params[:to].to_i
    ReorderProductBacklogUsecase.new.perform(product_id, pbi_id, to)
  end
end