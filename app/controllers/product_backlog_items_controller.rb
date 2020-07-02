class ProductBacklogItemsController < ApplicationController
  class Form
    include ActiveModel::Model

    attr_accessor :product_id, :content
  end

  def index
    @product_backlog_items = ProductBacklogItemQuery.call(params[:product_id])
  end

  def new
    @form = Form.new(product_id: params[:product_id])
  end

  def create
    product_id = Product::ProductId.from_string(params[:product_id])
    content = Pbi::Content.from_string(params[:form][:content])
    AddProductBacklogItemUsecase.new.perform(product_id, content)
    redirect_to product_backlog_items_path(product_id: product_id)
  end
end
