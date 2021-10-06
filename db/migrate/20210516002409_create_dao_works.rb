# typed: ignore
class CreateDaoWorks < ActiveRecord::Migration[6.0]
  def change
    create_table :dao_works do |t|
      t.references :dao_sprint, type: :uuid, foreign_key: true
      t.references :dao_issue, type: :uuid, foreign_key: true
      t.string :status, null: false
      t.integer :satisfied_criterion_numbers, array: true

      t.timestamps
    end

    add_index :dao_works, [:dao_sprint_id, :dao_issue_id], unique: true
  end
end
