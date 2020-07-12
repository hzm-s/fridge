class CreateDaoAcceptanceCriteria < ActiveRecord::Migration[6.0]
  def change
    create_table :dao_acceptance_criteria do |t|
      t.references :dao_product_backlog_item, type: :uuid, foreign_key: true, index: { name: 'idx_pbi_id_on_ac' }
      t.string :content, null: false

      t.timestamps
    end
  end
end
