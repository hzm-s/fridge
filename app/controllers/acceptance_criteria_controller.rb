# typed: ignore
class AcceptanceCriteriaController < ApplicationController
  before_action :require_user

  helper_method :pbi_id

  def create
    @form = AcceptanceCriterionForm.new(acceptance_criterion_params)
    if @form.valid?
      AppendAcceptanceCriterionUsecase.perform(pbi_id, @form.domain_objects[:content])
      redirect_to edit_pbi_path(id: pbi_id.to_s)
    else
      render :new
    end
  end

  def update
    @form = AcceptanceCriterionForm.new(acceptance_criterion_params)
    if @form.valid?
      ModifyAcceptanceCriterionUsecase.perform(
        pbi_id,
        params[:number].to_i,
        @form.domain_objects[:content],
      )
      redirect_to edit_pbi_path(id: pbi_id.to_s)
    else
      @criterion = PbiQuery.call(params[:pbi_id]).criteria.find { |ac| ac.number == params[:number].to_i }
      render :edit
    end
  end

  def destroy
    RemoveAcceptanceCriterionUsecase.perform(pbi_id, params[:number].to_i)
    redirect_to edit_pbi_path(pbi_id.to_s)
  end

  private

  def pbi_id
    @__pbi_id ||= Pbi::Id.from_string(params[:pbi_id])
  end

  def acceptance_criterion_params
    params.require(:form).permit(:content)
  end
end
