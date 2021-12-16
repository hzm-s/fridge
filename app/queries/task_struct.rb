# typed: false
class TaskStruct < SimpleDelegator
  attr_reader :sbi_id, :status

  def initialize(sbi_id, task)
    super(task)

    @sbi_id = sbi_id
    @status = Work::TaskStatus.from_string(task.status)
  end

  def available_activities
    status.available_activities.to_a.map(&:to_s)
  end
end
