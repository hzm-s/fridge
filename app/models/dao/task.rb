class Dao::Task < ApplicationRecord
  belongs_to :work, class_name: 'Dao::Work', foreign_key: :dao_work_id, optional: true
end
