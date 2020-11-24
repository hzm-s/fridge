class Dao::Plan < ApplicationRecord
  has_many :releases, -> { order :id }, class_name: 'Dao::Release', foreign_key: :dao_plan_id, dependent: :destroy

  def read
    Plan::Plan.from_repository(
      read_product_id,
      read_scoped,
      read_not_scoped,
    )
  end

  def write(plan)
    self.attributes = {
      not_scoped_issues: plan.not_scoped.to_a.map(&:to_s)
    }

    self.releases.clear
    plan.scoped.to_a.each do |r|
      self.releases.build(name: r.name.to_s, issues: r.issues.map(&:to_s))
    end
  end

  private

  def read_product_id
    Product::Id.from_string(dao_product_id)
  end

  def read_scoped
    releases
      .map { |r| Plan::Release.new(r.name, build_issue_list(r.issues)) }
      .then { |list| Plan::ReleaseList.new(list) }
  end

  def read_not_scoped
    build_issue_list(not_scoped_issues)
  end

  def build_issue_list(raw_issue_ids)
    raw_issue_ids.map { |i| Issue::Id.from_string(i) }
      .then { |ids| Plan::IssueList.new(ids) }
  end
end
