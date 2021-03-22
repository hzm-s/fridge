# typed: false
require_relative '../domain_support/plan_domain_support'

module PlanSupport
  include PlanDomainSupport

  def plan_of(product_id)
    PlanRepository::AR.find_by_product_id(product_id)
  end

  def update_plan(product_id)
    plan = PlanRepository::AR.find_by_product_id(product_id)
    yield(plan)
    PlanRepository::AR.store(plan)
  end

  def update_release(product_id, release_number)
    update_plan(product_id) do |plan|
      release = plan.release_of(release_number)
      yield(release)
      plan.update_release(release)
    end
  end

  def append_release(product_id, number = nil)
    plan = plan_of(product_id)
    return if number && plan.release_of(number)

    AppendReleaseUsecase.perform(team_roles(:po), product_id)
      .then { plan_of(product_id).releases.last }
  end
end

RSpec.configure do |c|
  c.include PlanSupport
end
