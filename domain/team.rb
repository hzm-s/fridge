# typed: strict
module Team
  class InvalidNewMember < StandardError; end
  class DuplicatedProductOwner < InvalidNewMember; end
  class DuplicatedScrumMaster < InvalidNewMember; end
  class TooLargeDevelopmentTeam < InvalidNewMember; end
  class AlreadyJoined < InvalidNewMember; end

  autoload :Member, 'team/member'
  autoload :Role, 'team/role'
  autoload :Team, 'team/team'
end
