# typed: strict
require 'sorbet-runtime'

class CompleteTaskUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(SbiRepository::AR, Sbi::SbiRepository)
  end

  sig {params(pbi_id: Pbi::Id, task_number: Integer).void}
  def perform(pbi_id, task_number)
    sbi = @repository.find_by_pbi_id(pbi_id)

    sbi.tasks.complete(task_number)
      .then { |tasks| sbi.update_tasks(tasks) }

    @repository.store(sbi)
  end
end
