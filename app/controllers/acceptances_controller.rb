class AcceptancesController < ApplicationController
  def show
    @issue = IssueQuery.call(params[:issue_id])
  end
end
