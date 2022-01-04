# typed: strict
require 'sorbet-runtime'

class ModifyTaskUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(WorkRepository::AR, Work::WorkRepository)
  end

  sig {params(pbi_id: Pbi::Id, task_number: Integer, content: Shared::ShortSentence).void}
  def perform(pbi_id, task_number, content)
    work = @repository.find_by_pbi_id(pbi_id)

    work.tasks.modify_content(task_number, content)
      .then { |tasks| work.update_tasks(tasks) }

    @repository.store(work)
  end
end
