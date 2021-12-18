# typed: strict
require 'sorbet-runtime'

class ModifyTaskUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(SbiRepository::AR, Sbi::SbiRepository)
  end

  sig {params(pbi_id: Pbi::Id, task_number: Integer, content: Shared::ShortSentence).void}
  def perform(pbi_id, task_number, content)
    sbi = @repository.find_by_pbi_id(pbi_id)

    sbi.tasks.modify_content(task_number, content)
      .then { |tasks| sbi.update_tasks(tasks) }

    @repository.store(sbi)
  end
end
