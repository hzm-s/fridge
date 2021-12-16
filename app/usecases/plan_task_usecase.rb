# typed: strict
require 'sorbet-runtime'

class PlanTaskUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(SbiRepository::AR, Sbi::SbiRepository)
  end

  sig {params(pbi_id: Pbi::Id, content: Shared::ShortSentence).void}
  def perform(pbi_id, content)
    sbi = @repository.find_by_id(pbi_id)

    sbi.tasks.append(content)
      .then { |tasks| sbi.update_tasks(tasks) }

    @repository.store(sbi)
  end
end
