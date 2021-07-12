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

  def update
    @form = AcceptanceCriterionForm.new(acceptance_criterion_params)
    @criterion = IssueQuery.call(params[:issue_id]).criteria.find { |ac| ac.number == params[:number].to_i }
    if @form.valid?
    else
      render :edit
    end
  end

  def destroy
    RemoveAcceptanceCriterionUsecase.perform(issue_id, params[:number].to_i)
    redirect_to edit_issue_path(issue_id.to_s)
  end

  private

  def issue_id
    @__issue_id ||= Issue::Id.from_string(params[:issue_id])
  end

  def acceptance_criterion_params
    params.require(:form).permit(:content)
  end
end
