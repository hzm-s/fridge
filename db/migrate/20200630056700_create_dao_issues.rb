# typed: ignore
class CreateDaoIssues < ActiveRecord::Migration[6.0]
  def change
    create_table :dao_issues, id: :uuid do |t|
      t.references :dao_product, type: :uuid, foreign_key: true, index: { name: 'idx_product_id_on_issues' }
      t.string :issue_type, null: false
      t.string :status, null: false
      t.boolean :accepted, null: false, default: false
      t.string :description, null: false
      t.integer :size

      t.timestamps
    end
  end
end
