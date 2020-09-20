# typed: strict
require 'sorbet-runtime'

class SwapIssuePrioritiesBetweenReleasesUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(ReleaseRepository::AR, Release::ReleaseRepository)
  end

  sig {params(item: Issue::Id, from_id: Release::Id, to_id: Release::Id, new_index: Integer).void}
  def perform(item, from_id, to_id, new_index)
    from = @repository.find_by_id(from_id)
    to = @repository.find_by_id(to_id)

    from.remove_item(item)
    to.add_item(item)
    to.swap_priorities(item, to.fetch_item(new_index))

    transaction do
      @repository.store(from)
      @repository.store(to)
    end
  end
end
