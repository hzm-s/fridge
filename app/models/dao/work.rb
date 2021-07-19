class Dao::Work < ApplicationRecord
  has_many :tasks, -> { order(:number) },
    class_name: 'Dao::Task', foreign_key: :dao_work_id,
    dependent: :destroy, autosave: true

  def write(work)
    self.attributes = {
      dao_issue_id: work.issue_id.to_s
    }

    self.tasks.each(&:mark_for_destruction)
    work.tasks.to_a.each do |t|
      self.tasks.build(number: t.number, content: t.content, status: t.status.to_s)
    end
  end

  def read
    Work::Work.from_repository(
      Issue::Id.from_string(dao_issue_id),
      read_tasks,
    )
  end

  private

  def read_tasks
    tasks.map do |t|
      Work::Task.from_repository(
        t.number,
        t.content,
        Work::TaskStatus.from_string(t.status),
      )
    end
  end
end
