# typed: false
module PlanDomainSupport
  def create_plan(product_id, issues_per_releases)
    roles = team_roles(:po)

    plan = Plan::Plan.create(product_id)

    issues_per_releases.each.with_index(1) do |issues, n|
      release = fetch_or_append_release(plan, n)
      issues.each { |i| release.plan_issue(i) }
      plan.update_release(roles, release)
    end

    plan
  end

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
