# typed: false
class Dao::Work < ApplicationRecord
  belongs_to :pbi, class_name: 'Dao::Pbi', foreign_key: :dao_pbi_id

  has_many :tasks, -> { order(:number) },
    class_name: 'Dao::Task', foreign_key: :dao_work_id,
    dependent: :destroy, autosave: true

  scope :as_aggregate, -> { eager_load(:tasks, pbi: :criteria) }

  def write(work)
    self.attributes = {
      dao_pbi_id: work.pbi_id.to_s,
      status: work.status.to_s,
    }

    self.tasks.each(&:mark_for_destruction)
    work.tasks.to_a.each do |t|
      self.tasks.build(number: t.number, content: t.content.to_s, status: t.status.to_s)
    end
  end

  def read
    Work::Work.from_repository(
      Pbi::Id.from_string(dao_pbi_id),
      read_tasks,
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
