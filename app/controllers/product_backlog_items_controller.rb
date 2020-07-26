# typed: false
class ProductBacklogItemsController < ApplicationController
  include ProductHelper

  before_action :require_user
  before_action :sanitize_status_filter, only: [:index]

  helper_method :current_product_id, :current_filter_status

  def index
    @items = ProductBacklogItemListQuery.call(params[:product_id])
    @form = ProductBacklogItemForm.new
  end

  def create
    @form = ProductBacklogItemForm.new(permitted_params)

    if @form.valid?
      AddProductBacklogItemUsecase.perform(
        Product::Id.from_string(params[:product_id]),
        @form.domain_objects[:content]
      )
      redirect_to product_product_backlog_items_path(product_id: params[:product_id]), flash: flash_success('pbi.create')
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
      UpdateProductBacklogItemUsecase.perform(
        Pbi::Id.from_string(@pbi_id),
        @pbi_form.domain_objects[:content]
      )
      redirect_to edit_product_backlog_item_path(@pbi_id), flash: flash_success('pbi.update')
    else
      render :edit
    end
  end

  def destroy
    pbi = ProductBacklogItemRepository::AR.find_by_id(Pbi::Id.from_string(params[:id]))
    RemoveProductBacklogItemUsecase.perform(pbi.id)
    redirect_to product_product_backlog_items_path(product_id: pbi.product_id), flash: flash_success('pbi.destroy')
  end

  private

  def permitted_params
    params.require(:form).permit(:content)
  end

  def sanitize_status_filter
    params[:status] && Pbi::Statuses.from_string(params[:status].to_s)
  rescue
    redirect_to product_product_backlog_items_path(product_id: params[:product_id])
  end

  def current_product_id
    product_id = params[:product_id]
    return product_id if product_id

    Dao::ProductBacklogItem.find(params[:id]).product_id
  end
end
