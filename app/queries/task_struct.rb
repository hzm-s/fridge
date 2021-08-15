# typed: false
class TaskStruct < SimpleDelegator
  attr_reader :issue_id, :status

  def initialize(issue_id, task)
    super(task)

    @issue_id = issue_id
    @status = Work::TaskStatus.from_string(task.status)
  end

  def available_activities
    status.available_activities.to_a.map(&:to_s)
  end
end
