# typed: false
module Team
  class DuplicateProductOwnerError < StandardError; end
  class DuplicateScrumMasterError < StandardError; end
  class LargeDevelopmentTeamError < StandardError; end
end
