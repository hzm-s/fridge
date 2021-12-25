# typed: false
class TaskStruct < SimpleDelegator
  attr_reader :pbi_id, :status

  def initialize(pbi_id, task)
    super(task)

    @pbi_id = pbi_id
    @status = Sbi::TaskStatus.from_string(task.status)
  end

  def available_activities
    status.available_activities.to_a.map(&:to_s)
  end
end
