# typed: strict
require 'sorbet-runtime'

class DropTaskUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(WorkRepository::AR, Work::WorkRepository)
  end

  sig {params(pbi_id: Pbi::Id, task_number: Integer).void}
  def perform(pbi_id, task_number)
    work = @repository.find_by_pbi_id(pbi_id)

    work.tasks.remove(task_number)
      .then { |tasks| work.update_tasks(tasks) }

    @repository.store(work)
  end
end
