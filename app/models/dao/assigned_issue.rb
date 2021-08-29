# typed: false
class Dao::AssignedIssue < ApplicationRecord
  belongs_to :issue, class_name: 'Dao::Issue', foreign_key: :dao_issue_id
end
