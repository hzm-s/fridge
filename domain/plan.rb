# typed: strict
module Plan
  class CanNotRemoveRelease < StandardError; end
  class AtLeastOneReleaseIsRequired < StandardError; end

  autoload :Plan, 'plan/plan'
  autoload :Release, 'plan/release'
end
