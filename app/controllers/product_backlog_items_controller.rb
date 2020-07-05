class ProductBacklogItemsController < ApplicationController

  def index
    @items = ProductBacklogItemListQuery.call(params[:product_id])
    @form = ProductBacklogItemForm.new(product_id: params[:product_id])
  end

  def create
    @form = ProductBacklogItemForm.new(create_params)

    if @form.valid?
      AddProductBacklogItemUsecase.new.perform(
        @form.domain_objects[:product_id],
        @form.domain_objects[:content]
      )
      redirect_to product_backlog_items_path(product_id: create_params[:product_id])
    else
      render :new
    end
  end

  private

  def create_params
    params.require(:form).permit(:product_id, :content)
  end
end
