# typed: strict
require 'sorbet-runtime'

class ChangeSprintWorkPriorityUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(SprintRepository::AR, Sprint::SprintRepository)
  end

  sig {params(product_id: Product::Id, roles: Team::RoleSet, pbi_id: Pbi::Id, to_index: Integer).void}
  def perform(product_id, roles, pbi_id, to_index)
    sprint = T.must(@repository.current(product_id))

    opposite = sprint.items.index_of(to_index)
    sprint.items.swap(pbi_id, opposite)
      .then { |items| sprint.update_items(roles, items) }

    @repository.store(sprint)
  end
end
