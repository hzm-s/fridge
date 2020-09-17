# typed: false
class AcceptanceCriteriaController < ApplicationController
  helper_method :issue_id

  def create
    @form = AcceptanceCriterionForm.new(permitted_params)
    if @form.valid?
      AddAcceptanceCriterionUsecase.perform(issue_id, @form.domain_objects[:content])
      redirect_to edit_issue_path(id: issue_id.to_s)
    else
      render :new
    end
  end

  def destroy
    dao = Dao::AcceptanceCriterion.find(params[:id])
    RemoveAcceptanceCriterionUsecase.perform(
      Pbi::Id.from_string(dao.dao_pbi_id),
      Pbi::AcceptanceCriterion.new(dao.content)
    )
    redirect_to edit_pbi_path(id: dao.dao_pbi_id)
  end

  private

  def issue_id
    @__issue_id ||= Issue::Id.from_string(params[:issue_id])
  end

  def permitted_params
    params.require(:form).permit(:content)
  end
end
