# typed: true
require_relative '../domain_support/plan_domain_support'

module PlanSupport
  include PlanDomainSupport
end

RSpec.configure do |c|
  c.include PlanSupport
end
