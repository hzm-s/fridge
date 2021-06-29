# typed: strict
require 'sorbet-runtime'

class ChangeWorkPriorityUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(SprintRepository::AR, Sprint::SprintRepository)
  end

  sig {params(product_id: Product::Id, roles: Team::RoleSet, issue_id: Issue::Id, to_index: Integer).void}
  def perform(product_id, roles, issue_id, to_index)
    sprint = @repository.current(product_id)

    opposite = T.must(sprint.issues.index_of(to_index))
    new_issues = sprint.issues.swap(issue_id, opposite)
    sprint.update_issues(new_issues)

    @repository.store(sprint)
  end
end
