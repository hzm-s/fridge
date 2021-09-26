# typed: strict
require 'sorbet-runtime'

class PlanTaskUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @work_repository = T.let(WorkRepository::AR, Work::WorkRepository)
    @issue_repository = T.let(IssueRepository::AR, Issue::IssueRepository)
  end

  sig {params(issue_id: Issue::Id, content: Shared::ShortSentence).void}
  def perform(issue_id, content)
    work = fetch_or_create_work(issue_id)

    work.tasks.append(content)
      .then { |tasks| work.update_tasks(tasks) }

    @work_repository.store(work)
  end

  private

  sig {params(issue_id: Issue::Id).returns(Work::Work)}
  def fetch_or_create_work(issue_id)
    work = @work_repository.find_by_issue_id(issue_id)
    return work if work

    issue = @issue_repository.find_by_id(issue_id)
    Work::Work.create(issue)
  end
end
