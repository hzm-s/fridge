# typed: strict
require 'sorbet-runtime'

class AcceptWorkUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(WorkRepository::AR, Work::WorkRepository)
  end

  sig {params(roles: Team::RoleSet, issue_id: Issue::Id).void}
  def perform(roles, issue_id)
    work = @repository.find_by_issue_id(issue_id)
    work.accept
    @repository.store(work)
  end
end
