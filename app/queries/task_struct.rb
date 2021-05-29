# typed: false
class TaskStruct < SimpleDelegator
  def initialize(work, task)
    @work = work
    super(task)
  end

  def issue_id
    @work.dao_issue_id
  end
end
