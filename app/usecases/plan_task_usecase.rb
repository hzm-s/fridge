# typed: strict
require 'sorbet-runtime'

class PlanTaskUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(WorkRepository::AR, Work::WorkRepository)
  end

  sig {params(issue_id: Issue::Id, content: String).void}
  def perform(issue_id, content)
    work = fetch_or_create_work(issue_id)
    work.append_task(content)
    @repository.store(work)
  end

  private

  sig {params(issue_id: Issue::Id).returns(Work::Work)}
  def fetch_or_create_work(issue_id)
    work = @repository.find_by_issue_id(issue_id)
    return work if work

    Work::Work.create(issue_id)
  end
end
