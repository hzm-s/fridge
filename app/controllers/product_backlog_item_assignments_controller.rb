class ProductBacklogItemAssignmentsController < ApplicationController
  def create
    pbi_id = Pbi::Id.from_string(params[:product_backlog_item_id])
    AssignProductBacklogItemUsecase.perform(pbi_id)
    @item = ProductBacklogItemQuery.call(pbi_id.to_s)
    render :show
  end

  def destroy
    pbi_id = Pbi::Id.from_string(params[:id])
    CancelProductBacklogItemAssignmentUsecase.perform(pbi_id)
    @item = ProductBacklogItemQuery.call(pbi_id.to_s)
    render :show
  end
end
