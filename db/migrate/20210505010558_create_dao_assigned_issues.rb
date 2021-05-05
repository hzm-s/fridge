class CreateDaoAssignedIssues < ActiveRecord::Migration[6.0]
  def change
    create_table :dao_assigned_issues do |t|
      t.references :dao_sprint, type: :uuid, foreign_key: true
      t.references :dao_issue, type: :uuid, foreign_key: true

      t.timestamps
    end
  end
end
