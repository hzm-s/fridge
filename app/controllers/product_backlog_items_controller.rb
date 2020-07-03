class ProductBacklogItemsController < ApplicationController

  def index
    @product_backlog_items = ProductBacklogItemQuery.call(params[:product_id])
  end

  def new
    @form = ProductBacklogItemForm.new(product_id: params[:product_id])
  end

  def create
    @form = ProductBacklogItemForm.new(permitted_params)

    if @form.valid?
      AddProductBacklogItemUsecase.new.perform(
        @form.domain_objects[:product_id],
        @form.domain_objects[:content]
      )
      redirect_to product_backlog_items_path(product_id: permitted_params[:product_id])
    else
      render :new
    end
  end

  private

  def permitted_params
    params.require(:form).permit(:product_id, :content)
  end
end
