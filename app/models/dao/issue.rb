# typed: false
class Dao::Issue < ApplicationRecord
  has_many :criteria, -> { order :id }, class_name: 'Dao::AcceptanceCriterion', foreign_key: :dao_issue_id, dependent: :destroy
  has_one :release_item, class_name: 'Dao::ReleaseItem', foreign_key: :dao_issue_id
  
  delegate :dao_release_id, to: :release_item, allow_nil: true
end
