# typed: strict
require 'sorbet-runtime'

class SortProductBacklogUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(ReleaseRepository::AR, Release::ReleaseRepository)
  end

  sig {params(from_id: Release::Id, item_id: Pbi::Id, to_id: Release::Id, position: Integer).void}
  def perform(from_id, item_id, to_id, position)
    from = @repository.find_by_id(from_id)
    to = @repository.find_by_id(to_id)

    sorter = Release::ItemSorter.new(from, item_id, to, position)
    releases = sorter.sort

    transaction do
      releases.each do |release|
        @repository.update(release)
      end
    end
  end
end
