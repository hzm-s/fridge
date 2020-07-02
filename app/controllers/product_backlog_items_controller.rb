class ProductBacklogItemsController < ApplicationController
  def index
    @product_backlog_items = ProductBacklogItemQuery.call(params[:product_id])
  end

  def create
    product_id = Product::ProductId.from_string(params[:product_id])
    content = Pbi::Content.from_string(params[:form][:content])
    AddProductBacklogItemUsecase.new.perform(product_id, content)
  end
end
