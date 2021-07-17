# typed: false
class CreateDaoAcceptanceCriteria < ActiveRecord::Migration[6.0]
  def change
    create_table :dao_acceptance_criteria do |t|
      t.references :dao_issue, type: :uuid, foreign_key: true
      t.integer :number, null: false
      t.string :content, null: false
      t.boolean :satisfied, null: false, default: false

      t.timestamps
    end

    add_index :dao_acceptance_criteria, [:dao_issue_id, :number], unique: true
  end
end
