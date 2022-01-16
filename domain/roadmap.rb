# typed: strict
module Roadmap
  class ReleaseIsNotEmpty < StandardError; end
  class NeedAtLeastOneRelease < StandardError; end
  class DuplicatedItem < StandardError; end
  class PermissionDenied < StandardError; end
  class ReleaseNotFound < StandardError; end

  autoload :Roadmap, 'roadmap/roadmap'
  autoload :Release, 'roadmap/release'
  autoload :RoadmapRepository, 'roadmap/roadmap_repository'
  autoload :ChangeRoadmap, 'roadmap/change_roadmap'
end
