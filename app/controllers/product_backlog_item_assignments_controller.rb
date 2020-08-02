class ProductBacklogItemAssignmentsController < ApplicationController
  def create
    AssignProductBacklogItemUsecase.perform(pbi_id)

    @item = ProductBacklogItemQuery.call(pbi_id.to_s)
    flash.now[:notice] = feedback_message('pbi.assigned')
    render :show
  end

  def destroy
    CancelProductBacklogItemAssignmentUsecase.perform(pbi_id)

    @item = ProductBacklogItemQuery.call(pbi_id.to_s)
    flash.now[:notice] = feedback_message('pbi.cancel_assignment')
    render :show
  end

  private

  def pbi_id
    @__pbi_id ||= Pbi::Id.from_string(params[:id])
  end
end
