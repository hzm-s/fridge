# typed: strict
module Team
  class InvalidNewMember < StandardError; end
  class DuplicatedProductOwner < InvalidNewMember; end
  class DuplicatedScrumMaster < InvalidNewMember; end
  class TooLargeDevelopmentTeam < InvalidNewMember; end
end
