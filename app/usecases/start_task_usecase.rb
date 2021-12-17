# typed: strict
require 'sorbet-runtime'

class StartTaskUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(SbiRepository::AR, Sbi::SbiRepository)
  end

  sig {params(sbi_id: Pbi::Id, task_number: Integer).void}
  def perform(sbi_id, task_number)
    sbi = @repository.find_by_id(sbi_id)

    sbi.tasks.start(task_number)
      .then { |tasks| sbi.update_tasks(tasks) }

    @repository.store(sbi)
  end
end
