# typed: false
class Dao::Sprint < ApplicationRecord
  has_many :issues, -> { order(:id) }, class_name: 'Dao::AssignedIssue', foreign_key: :dao_sprint_id, dependent: :destroy

  def write(sprint)
    self.attributes = {
      dao_product_id: sprint.product_id.to_s,
      number: sprint.number,
      is_finished: sprint.finished?,
    }
    self.issues.clear
    sprint.issues.to_a.each do |i|
      self.issues.build(dao_issue_id: i.to_s)
    end
  end

  def read
    Sprint::Sprint.from_repository(
      Sprint::Id.from_string(id),
      Product::Id.from_string(dao_product_id),
      number,
      is_finished,
      read_issues,
    )
  end

  private

  def read_issues
    issues.map { |i| Issue::Id.from_string(i.dao_issue_id) }
      .then { |ids| Issue::List.new(ids) }
  end
end
