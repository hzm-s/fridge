# typed: false
class Dao::Sbi < ApplicationRecord
  belongs_to :pbi, class_name: 'Dao::Pbi', foreign_key: :dao_pbi_id

  has_many :tasks, -> { order(:number) },
    class_name: 'Dao::Task', foreign_key: :dao_sbi_id,
    dependent: :destroy, autosave: true

  scope :as_aggregate, -> { eager_load(:tasks, pbi: :criteria) }

  def write(sbi)
    self.attributes = {
      dao_pbi_id: sbi.pbi_id.to_s,
    }

    self.tasks.each(&:mark_for_destruction)
    sbi.tasks.to_a.each do |t|
      self.tasks.build(number: t.number, content: t.content.to_s, status: t.status.to_s)
    end
  end

  def read
    Sbi::Sbi.from_repository(
      Sbi::Id.from_string(id),
      Pbi::Id.from_string(dao_pbi_id),
      read_tasks,
    )
  end

  def read_tasks
    tasks.map do |t|
      Sbi::Task.from_repository(
        t.number,
        Shared::ShortSentence.new(t.content),
        Sbi::TaskStatus.from_string(t.status),
      )
    end
      .then { |objs| Sbi::TaskList.new(objs) }
  end
end
