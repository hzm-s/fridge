# typed: strict
module Team
  class InvalidRole < ArgumentError; end
  class InvalidNewMember < StandardError; end
  class DuplicatedProductOwner < InvalidNewMember; end
  class DuplicatedScrumMaster < InvalidNewMember; end
  class TooLargeDevelopmentTeam < InvalidNewMember; end
  class AlreadyJoined < InvalidNewMember; end

  autoload :Id, 'team/id'
  autoload :Team, 'team/team'
  autoload :Member, 'team/member'
  autoload :Role, 'team/role'
  autoload :TeamRepository, 'team/team_repository'
end
