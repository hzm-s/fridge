# typed: false
class Dao::Issue < ApplicationRecord
  has_many :criteria, class_name: 'Dao::AcceptanceCriterion', foreign_key: :dao_issue_id, dependent: :destroy
end
