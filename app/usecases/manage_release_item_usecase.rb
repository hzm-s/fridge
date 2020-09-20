# typed: strict
require 'sorbet-runtime'

class ManageReleaseItemUsecase < UsecaseBase
  extend T::Sig

  From = T.type_alias {T.nilable(Release::Id)}
  To = T.type_alias {T.nilable(Release::Id)}

  sig {params(item: Issue::Id, from_release_id: From, to_release_id: To, new_index: Integer).void}
  def perform(item, from_release_id, to_release_id, new_index)
    case [from_release_id, to_release_id]
    when [nil, to_release_id]
      transaction do
        AddReleaseItemUsecase.perform(item, to_release_id)
        SwapReleaseItemPrioritiesUsecase.perform(to_release_id, item, new_index)
      end
    when [from_release_id, nil]
      RemoveReleaseItemUsecase.perform(item, from_release_id)
    else
      if from_release_id == to_release_id
        SwapReleaseItemPrioritiesUsecase.perform(from_release_id, item, new_index)
      else
        RemoveReleaseItemUsecase.perform(item, from_release_id)
        AddReleaseItemUsecase.perform(item, to_release_id)
        SwapReleaseItemPrioritiesUsecase.perform(to_release_id, item, new_index)
      end
    end
  end
end
