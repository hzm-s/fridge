class ProductBacklogItemsController < ApplicationController
  def index
    @product_backlog_items = ProductBacklogItemQuery.call(params[:product_id])
  end

  def create
  end
end
