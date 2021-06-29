# typed: false
module SprintSupport
  def start_sprint(product_id)
    StartSprintUsecase.perform(product_id)
      .then { |id| SprintRepository::AR.find_by_id(id) }
  end

  def assign_issue_to_sprint(product_id, *issue_ids)
    issue_ids.each do |issue_id|
      AssignIssueToSprintUsecase.perform(product_id, team_roles(:po), issue_id)
    end
  end
end

RSpec.configure do |c|
  c.include SprintSupport
end
