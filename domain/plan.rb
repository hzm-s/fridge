# typed: true

module Plan
  class ReleaseNotFound < StandardError; end

  autoload :Plan, 'plan/plan'
  autoload :Release, 'plan/release'
  autoload :PlanRepository, 'plan/plan_repository'
end
