# typed: false
class PlansController < ApplicationController
  def update
    product_id = Product::Id.from_string(params[:product_id])
    issue_id = Issue::Id.from_string(params[:issue_id])
    to_index = params[:to_index].to_i

    SortIssuesUsecase.perform(product_id, issue_id, to_index)
  end
end
