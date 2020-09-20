# typed: strict
require 'sorbet-runtime'

class ManageReleaseItemUsecase < UsecaseBase
  extend T::Sig

  Item = T.type_alias {Issue::Id}
  From = T.type_alias {T.nilable(Release::Id)}
  To = T.type_alias {T.nilable(Release::Id)}

  sig {void}
  def initialize
    @repository = T.let(ReleaseRepository::AR, Release::ReleaseRepository)
  end

  sig {params(item: Item, from_release_id: From, to_release_id: To, new_index: Integer).void}
  def perform(item, from_release_id, to_release_id, new_index)
    case [from_release_id, to_release_id]
    when [nil, to_release_id]
      to = @repository.find_by_id(to_release_id)
      add_release_item(item, to)
      swap_item_priorities(to, item, new_index)
      @repository.store(to)

    when [from_release_id, nil]
      from = @repository.find_by_id(from_release_id)
      remove_release_item(item, from)
      @repository.store(from)

    else
      if from_release_id == to_release_id
        release = @repository.find_by_id(from_release_id)
        swap_item_priorities(release, item, new_index)
        @repository.store(release)
      else
        from = @repository.find_by_id(from_release_id)
        to = @repository.find_by_id(to_release_id)

        remove_release_item(item, from)
        add_release_item(item, to)
        swap_item_priorities(to, item, new_index)

        transaction do
          @repository.store(from)
          @repository.store(to)
        end
      end
    end
  end

  private

  sig {params(item: Item, to: Release::Release).void}
  def add_release_item(item, to)
    to.add_item(item)
  end

  sig {params(item: Item, release: Release::Release).void}
  def remove_release_item(item, release)
    release.remove_item(item)
  end

  sig {params(release: Release::Release, item: Item, new_index: Integer).void}
  def swap_item_priorities(release, item, new_index)
    target = release.fetch_item(new_index)
    release.swap_priorities(item, target)
  end
end
