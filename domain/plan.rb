# typed: strict
module Plan
  class ReleaseNotFound < StandardError; end
  class CanNotRemoveRelease < StandardError; end

  autoload :Plan, 'plan/plan'
  autoload :ReleaseSequence, 'plan/release_sequence'
  autoload :Release, 'plan/release'
  autoload :ItemList, 'plan/item_list'
  autoload :PlanRepository, 'plan/plan_repository'
end
