# typed: false
module PlanDomainSupport
  def plan_order(issue_ids)
    Plan::Order.new(issue_ids)
  end
end

RSpec.configure do |c|
  c.include PlanDomainSupport
end
