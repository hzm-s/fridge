# typed: false
class AcceptanceCriteriaController < ApplicationController
  helper_method :feature_id

  def create
    @form = AcceptanceCriterionForm.new(permitted_params)
    if @form.valid?
      AddAcceptanceCriterionUsecase.perform(feature_id, @form.domain_objects[:content])
      redirect_to edit_feature_path(id: feature_id.to_s)
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

  def feature_id
    @__feature_id ||= Feature::Id.from_string(params[:feature_id])
  end

  def permitted_params
    params.require(:form).permit(:content)
  end
end
