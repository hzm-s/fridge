class Dao::Work < ApplicationRecord
  has_many :tasks, class_name: 'Dao::Task', foreign_key: :dao_work_id, dependent: :destroy

  def write(work)
    self.attributes = {
      dao_issue_id: work.issue_id.to_s
    }
    self.tasks.clear
    work.tasks.to_a.each do |t|
      self.tasks.build(number: t.number, content: t.content)
    end
  end
end
