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

  def add_release(product_id, name)
    AppendReleaseUsecase.perform(team_roles(:po), product_id, name)
    PlanRepository::AR.find_by_product_id(product_id)
  end
end

RSpec.configure do |c|
  c.include PlanSupport
end
