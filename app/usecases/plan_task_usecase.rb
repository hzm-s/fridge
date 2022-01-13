# typed: strict
require 'sorbet-runtime'

class PlanTaskUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(WorkRepository::AR, Work::WorkRepository)
  end

  sig {params(pbi_id: Pbi::Id, content: Shared::ShortSentence).void}
  def perform(pbi_id, content)
    work = @repository.find_or_assign_by_pbi_id(pbi_id)

    work.tasks.append(content)
      .then { |tasks| work.update_tasks(tasks) }

    @repository.store(work)
  end
end
