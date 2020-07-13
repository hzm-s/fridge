class CreateDaoAcceptanceCriteria < ActiveRecord::Migration[6.0]
  def change
    create_table :dao_acceptance_criteria do |t|
      t.references :dao_product_backlog_item, type: :uuid, foreign_key: true, index: false
      t.integer :no, null: false
      t.string :content, null: false

      t.timestamps
    end

    add_index :dao_acceptance_criteria, [:dao_product_backlog_item_id, :no], unique: true, name: 'index_pbi_id_and_no_on_ac'
  end
end
