# typed: strict
require 'sorbet-runtime'

class ManageReleaseItemUsecase < UsecaseBase
  extend T::Sig

  Item = T.type_alias {Issue::Id}
  FromId = T.type_alias {T.nilable(Release::Id)}
  ToId = T.type_alias {T.nilable(Release::Id)}

  sig {params(item: Item, from_id: FromId, to_id: ToId, new_index: Integer).void}
  def perform(item, from_id, to_id, new_index)
    case [from_id, to_id]
    when [nil, to_id]
      PlanIssueReleaseUsecase.perform(item, to_id, new_index)

    when [from_id, nil]
      CancelIssueReleaseUsecase.perform(item, from_id)

    else
      if (from_id && to_id) && from_id == to_id
        SwapIssuePrioritiesUsecase.perform(item, from_id, new_index)
      else
        SwapIssuePrioritiesBetweenReleasesUsecase.perform(item, from_id, to_id, new_index)
      end
    end
  end
end
