class AcceptanceCriteriaController < ApplicationController
  helper_method :pbi_id

  def create
    @form = AcceptanceCriterionForm.new(permitted_params)
    if @form.valid?
      AddAcceptanceCriterionUsecase.new.perform(pbi_id, params[:form][:content])
      redirect_to edit_product_backlog_item_path(id: pbi_id.to_s)
    else
      render :new
    end
  end

  def destroy
    RemoveAcceptanceCriterionUsecase.new.perform(pbi_id, params[:no].to_i)
    redirect_to edit_product_backlog_item_path(id: pbi_id.to_s)
  end

  private

  def pbi_id
    @__pbi_id ||= Pbi::Id.from_string(params[:product_backlog_item_id])
  end

  def permitted_params
    params.require(:form).permit(:content)
  end
end
