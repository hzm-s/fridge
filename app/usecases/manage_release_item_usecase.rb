# typed: strict
require 'sorbet-runtime'

class ManageReleaseItemUsecase < UsecaseBase
  extend T::Sig

  Item = T.type_alias {Issue::Id}
  FromId = T.type_alias {T.nilable(Release::Id)}
  ToId = T.type_alias {T.nilable(Release::Id)}

  sig {void}
  def initialize
    @repository = T.let(ReleaseRepository::AR, Release::ReleaseRepository)
  end

  sig {params(item: Item, from_id: FromId, to_id: ToId, new_index: Integer).void}
  def perform(item, from_id, to_id, new_index)
    case [from_id, to_id]
    when [nil, to_id]
      add_release_item(item, to_id, new_index)

    when [from_id, nil]
      remove_release_item(item, from_id)

    else
      if from_id == to_id
        swap_item_priorities_in_same_release(item, from_id, new_index)
      else
        swap_item_priorities_in_releases(item, from_id, to_id, new_index)
      end
    end
  end

  private

  sig {params(item: Item, release_id: Release::Id, new_index: Integer).void}
  def add_release_item(item, release_id, new_index)
    to = @repository.find_by_id(release_id)
    to.add_item(item)
    to.swap_priorities(item, to.fetch_item(new_index))
    @repository.store(to)
  end

  sig {params(item: Item, release_id: Release::Id).void}
  def remove_release_item(item, release_id)
    release = @repository.find_by_id(release_id)
    release.remove_item(item)
    @repository.store(release)
  end

  sig {params(item: Item, release_id: Release::Id, new_index: Integer).void}
  def swap_item_priorities_in_same_release(item, release_id, new_index)
    release = @repository.find_by_id(release_id)
    release.swap_priorities(item, release.fetch_item(new_index))
    @repository.store(release)
  end

  sig {params(item: Item, from_id: Release::Id, to_id: Release::Id, new_index: Integer).void}
  def swap_item_priorities_in_releases(item, from_id, to_id, new_index)
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
