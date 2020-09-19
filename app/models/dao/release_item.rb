class Dao::ReleaseItem < ApplicationRecord
  belongs_to :release, class_name: 'Dao::Release', foreign_key: :dao_release_id
  belongs_to :issue, class_name: 'Dao::Issue', foreign_key: :dao_issue_id
end
