# typed: strict
module Release
  class CanNotRemove < StandardError; end

  autoload :Id, 'release/id'
  autoload :Release, 'release/release'
  autoload :ItemList, 'release/item_list'
  autoload :ReleaseRepository, 'release/release_repository'
end
