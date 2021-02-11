# typed: false
class PlansController < ApplicationController
  include ProductHelper

  def update
    product_id = Product::Id.from_string(current_product_id)
    roles = current_team_member(current_user.person_id).roles
    issue_id = Issue::Id.from_string(params[:issue_id])
    to_index = params[:to_index].to_i
    to = params[:to]
    from = params[:from]

    case [from, to].map(&:present?)
    when [false, false]
      SortIssuesUsecase.perform(product_id, issue_id, to_index)
    when [true, false]
      PendIssueUsecase.perform(product_id, roles, issue_id, from)
    when [false, true]
      ScheduleIssueUsecase.perform(product_id, roles, issue_id, to, to_index)
    when [true, true]
      if from == to
        ChangeIssuePriorityUsecase.perform(product_id, roles, from, issue_id, to_index)
      else
        ChangeReleaseOfIssueUsecase.perform(product_id, roles, issue_id, from ,to, to_index)
      end
    else
      raise 'Unknown issue moving'
    end
  end

  private

  def current_product_id
    params[:product_id]
  end
end
