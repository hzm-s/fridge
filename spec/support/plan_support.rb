# typed: false
require_relative '../domain_support/plan_domain_support'

module PlanSupport
  include PlanDomainSupport

  def add_release(product_id, name)
    AppendReleaseUsecase.perform(product_id, name)
    PlanRepository::AR.find_by_product_id(product_id)
  end
end

RSpec.configure do |c|
  c.include PlanSupport
end
