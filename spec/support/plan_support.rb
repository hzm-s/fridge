# typed: false
require_relative '../domain_support/plan_domain_support'

module PlanSupport
  include PlanDomainSupport

  def roadmap_of(product_id)
    RoadmapRepository::AR.find_by_product_id(product_id)
  end

  def update_plan(product_id)
    plan = PlanRepository::AR.find_by_product_id(product_id)
    yield(plan)
    PlanRepository::AR.store(plan)
  end

  def update_release(product_id, release_number)
    update_plan(product_id) do |plan|
      release = plan.release_of(release_number)
      new_release = yield(release)
      plan.update_release(team_roles(:po), new_release)
    end
  end

  def append_release(product_id, number = nil, title: nil)
    roadmap = roadmap_of(product_id)
    return if number && find_release_by_number(roadmap, number)

    AppendReleaseUsecase.perform(team_roles(:po), product_id, name(title))
      .then { roadmap_of(product_id).releases.last }
  end

  private

  def find_release_by_number(plan, number)
    plan.release_of(number)
  rescue Plan::ReleaseNotFound
    nil
  end
end

RSpec.configure do |c|
  c.include PlanSupport
end
