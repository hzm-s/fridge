# typed: false
module PlanDomainSupport
  def issue_list(*issue_ids)
    Plan::IssueList.new(issue_ids)
  end
end

RSpec.configure do |c|
  c.include PlanDomainSupport
end
