# typed: false
class CreateDaoAcceptanceCriteria < ActiveRecord::Migration[6.0]
  def change
    create_table :dao_acceptance_criteria do |t|
      t.references :dao_issue, type: :uuid, foreign_key: true
      t.string :content, null: false

      t.timestamps
    end
  end
end
