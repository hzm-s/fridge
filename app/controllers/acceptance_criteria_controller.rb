# typed: false
class AcceptanceCriteriaController < ApplicationController
  helper_method :pbi_id

  def create
    @form = AcceptanceCriterionForm.new(permitted_params)
    if @form.valid?
      AddAcceptanceCriterionUsecase.perform(pbi_id, @form.domain_objects[:content])
      redirect_to edit_product_backlog_item_path(id: pbi_id.to_s)
    else
      render :new
    end
  end

  def destroy
    dao = Dao::AcceptanceCriterion.find(params[:id])
    RemoveAcceptanceCriterionUsecase.perform(
      Pbi::Id.from_string(dao.dao_product_backlog_item_id),
      Pbi::AcceptanceCriterion.new(dao.content)
    )
    redirect_to edit_product_backlog_item_path(id: dao.dao_product_backlog_item_id)
  end

  private

  def pbi_id
    @__pbi_id ||= Pbi::Id.from_string(params[:product_backlog_item_id])
  end

  def permitted_params
    params.require(:form).permit(:content)
  end
end
