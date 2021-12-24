# typed: false
module PlanDomainSupport
  def fetch_or_append_release(plan, release_number)
    plan.release_of(release_number)
  rescue Plan::ReleaseNotFound
    plan.append_release(team_roles(:po))
    retry
  end
end

RSpec.configure do |c|
  c.include PlanDomainSupport
end
