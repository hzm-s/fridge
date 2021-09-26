# typed: strict
require 'sorbet-runtime'

class DissatisfyAcceptanceCriterionUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(WorkRepository::AR, Work::WorkRepository)
  end

  sig {params(roles: Team::RoleSet, issue_id: Issue::Id, criterion_number: Integer).void}
  def perform(roles, issue_id, criterion_number)
    work = @repository.find_by_issue_id(issue_id)

    work.dissatisfy_acceptance_criterion(criterion_number)

    @repository.store(work)
  end
end
