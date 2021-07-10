# typed: false
class AcceptanceCriteriaController < ApplicationController
  helper_method :issue_id

  def create
    @form = AcceptanceCriterionForm.new(acceptance_criterion_params)
    if @form.valid?
      AppendAcceptanceCriterionUsecase.perform(issue_id, @form.content)
      redirect_to edit_issue_path(id: issue_id.to_s)
    else
      render :new
    end
  end

  def destroy
    dao = Dao::AcceptanceCriterion.find(params[:id])
    RemoveAcceptanceCriterionUsecase.perform(
      Issue::Id.from_string(dao.dao_issue_id),
      Issue::AcceptanceCriterion.new(dao.content)
    )
    redirect_to edit_issue_path(id: dao.dao_issue_id)
  end

  private

  def issue_id
    @__issue_id ||= Issue::Id.from_string(params[:issue_id])
  end

  def acceptance_criterion_params
    params.require(:form).permit(:content)
  end
end
