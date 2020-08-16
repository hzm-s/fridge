# typed: false

module Release
  class CanNotRemoveRelease < StandardError; end

  autoload :ReleaseRepository, 'release/release_repository'

  autoload :Id, 'release/id'
  autoload :Release, 'release/release'

  autoload :ItemSorter, 'release/item_sorter'
end
