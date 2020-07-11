class ProductBacklogItemOrdersController < ApplicationController
  def update
    product_id = Product::ProductId.from_string(params[:product_id])
    src = Pbi::ItemId.from_string(params[:src])
    dst = Pbi::ItemId.from_string(params[:dst])
    ReorderProductBacklogUsecase.new.perform(product_id, src, dst)
  end
end
