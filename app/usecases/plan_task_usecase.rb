# typed: strict
require 'sorbet-runtime'

class PlanTaskUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(WorkRepository::AR, Work::WorkRepository)
  end

  sig {params(issue_id: Issue::Id, content: Shared::ShortSentence).void}
  def perform(issue_id, content)
    work = @repository.find_by_issue_id(issue_id)

    work.tasks.append(content)
      .then { |tasks| work.update_tasks(tasks) }

    @repository.store(work)
  end
end
