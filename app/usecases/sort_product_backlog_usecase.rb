# typed: strict
require 'sorbet-runtime'

class SortProductBacklogUsecase < UsecaseBase
  extend T::Sig

  From = T.type_alias {T.nilable(Release::Id)}
  To = T.type_alias {T.nilable(Release::Id)}

  sig {params(item: Issue::Id, from_release_id: From, to_release_id: To, new_index: Integer).void}
  def perform(item, from_release_id, to_release_id, new_index)
    if from_release_id.nil?
      AddReleaseItemUsecase.perform(item, to_release_id)
    else
      RemoveReleaseItemUsecase.perform(item, from_release_id)
    end
  end
end
