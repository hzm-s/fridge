# typed: false
class Dao::Work < ApplicationRecord
  belongs_to :issue, class_name: 'Dao::Issue', foreign_key: :dao_issue_id

  has_many :tasks, -> { order(:number) },
    class_name: 'Dao::Task', foreign_key: :dao_work_id,
    dependent: :destroy, autosave: true

  scope :as_aggregate, -> { eager_load(:tasks, issue: :criteria) }

  def write(work)
    self.attributes = {
      dao_issue_id: work.issue_id.to_s,
      status: work.status.to_s,
      satisfied_criterion_numbers: work.acceptance.satisfied_criteria.to_a,
    }

    self.tasks.each(&:mark_for_destruction)
    work.tasks.to_a.each do |t|
      self.tasks.build(number: t.number, content: t.content.to_s, status: t.status.to_s)
    end
  end

  def read
    Work::Work.from_repository(
      Issue::Id.from_string(dao_issue_id),
      read_status,
      read_acceptance,
      read_tasks,
    )
  end

  def read_status
    Work::Statuses.from_string(status)
  end

  def read_acceptance
    Work::Acceptance.new(
      issue.read_acceptance_criteria,
      satisfied_criterion_numbers.to_set,
    )
  end

  def read_tasks
    tasks.map do |t|
      Work::Task.from_repository(
        t.number,
        Shared::ShortSentence.new(t.content),
        Work::TaskStatus.from_string(t.status),
      )
    end
      .then { |objs| Work::TaskList.new(objs) }
  end
end
