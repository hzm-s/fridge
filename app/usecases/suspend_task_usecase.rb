# typed: strict
require 'sorbet-runtime'

class SuspendTaskUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(WorkRepository::AR, Work::WorkRepository)
  end

  sig {params(issue_id: Issue::Id, task_number: Integer).void}
  def perform(issue_id, task_number)
    work = T.must(@repository.find_by_issue_id(issue_id))

    work.tasks.of(task_number).suspend

    @repository.store(work)
  end
end
