class AcceptanceCriteriaController < ApplicationController
  def create
    pbi_id = Pbi::ItemId.from_string(params[:product_backlog_item_id])
    AddAcceptanceCriterionUsecase.new.perform(pbi_id, params[:form][:content])
  end
end
