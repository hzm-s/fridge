class Dao::Work < ApplicationRecord
  has_many :tasks, class_name: 'Dao::Task', dependent: :destroy

  def write(work)
    self.attributes = {
      dao_issue_id: work.issue_id.to_s
    }
  end
end
