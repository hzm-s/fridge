# typed: strict
require 'sorbet-runtime'

class ModifyTaskUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(WorkRepository::AR, Work::WorkRepository)
  end

  sig {params(issue_id: Issue::Id, number: Integer, content: String).void}
  def perform(issue_id, number, content)
    work = @repository.find_by_issue_id(issue_id)
    work.modify_task(number, content)
    @repository.store(work)
  end
end
