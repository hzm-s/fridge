# typed: strict
module Release
  class ReleaseNotFound < StandardError; end

  autoload :Release, 'release/release'
  autoload :ItemList, 'release/item_list'
  autoload :ReleaseRepository, 'release/release_repository'
  autoload :Sequence, 'release/sequence'
end
