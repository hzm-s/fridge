class SatisfiedAcceptanceCriteriaController < ApplicationController
  def create
    issue_id = Issue::Id.from_string(params[:issue_id])
    number = params[:number].to_i
    SatisfyAcceptanceCriterionUsecase.perform(issue_id, number)

    redirect_to issue_acceptance_path(issue_id: issue_id.to_s)
  end
end
