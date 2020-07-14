class ProductBacklogItemsController < ApplicationController
  helper_method :current_product

  def index
    @items = ProductBacklogItemListQuery.call(params[:product_id])
    @form = ProductBacklogItemForm.new
  end

  def create
    @form = ProductBacklogItemForm.new(permitted_params)

    if @form.valid?
      AddProductBacklogItemUsecase.perform(
        Product::ProductId.from_string(params[:product_id]),
        @form.domain_objects[:content]
      )
      redirect_to product_product_backlog_items_path(product_id: params[:product_id])
    else
      render :new
    end
  end

  def edit
    @pbi = ProductBacklogItemQuery.call(params[:id])
    @pbi_form = ProductBacklogItemForm.new(content: @pbi.content)
  end

  def update
    @pbi_id = params[:id]
    @pbi_form = ProductBacklogItemForm.new(permitted_params)

    if @pbi_form.valid?
      render
    else
      render :edit
    end
  end

  private

  def permitted_params
    params.require(:form).permit(:content)
  end

  def current_product(product_id)
    Dao::Product.find_by(id: product_id)
  end
end
