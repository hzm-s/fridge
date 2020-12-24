# typed: false
class PlansController < ApplicationController
  def update
    product_id = Product::Id.from_string(params[:product_id])
    issue_id = Issue::Id.from_string(params[:issue_id])
    to_index = params[:to_index].to_i
    to = params[:to]
    from = params[:from]

    case [from, to].map(&:present?)
    when [false, false]
      SortIssuesUsecase.perform(product_id, issue_id, to_index)
    when [true, false]
      PendingIssueUsecase.perform(product_id, issue_id, from)
    when [false, true]
      ScheduleIssueUsecase.perform(product_id, issue_id, to, to_index)
    when [true, true]
      if from == to
        ChangeIssuePriorityUsecase.perform(product_id, from, issue_id, to_index)
      else
        ChangeReleaseOfIssueUsecase.perform(product_id, issue_id, from ,to, to_index)
      end
    else
      raise 'Unknown issue moving'
    end
  end
end
