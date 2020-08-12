# typed: strict
module Plan
  class ReleaseContainsItem < StandardError; end
  class AtLeastOneReleaseIsRequired < StandardError; end

  autoload :Plan, 'plan/plan'
  autoload :Release, 'plan/release'
end
