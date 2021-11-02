# typed: strict
module Plan
  class ReleaseIsNotEmpty < StandardError; end
  class NeedAtLeastOneRelease < StandardError; end
  class DuplicatedItem < StandardError; end
  class PermissionDenied < StandardError; end
  class ReleaseNotFound < StandardError; end

  autoload :Plan, 'plan/plan'
  autoload :Release, 'plan/release'
  autoload :PlanRepository, 'plan/plan_repository'
end
