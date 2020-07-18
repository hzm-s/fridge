# typed: ignore
class CreateDaoProductBacklogItems < ActiveRecord::Migration[6.0]
  def change
    create_table :dao_product_backlog_items, id: :uuid do |t|
      t.references :dao_product, type: :uuid, foreign_key: true, index: { name: 'idx_product_id_on_pbis' }
      t.string :content, null: false
      t.integer :next_acceptance_criterion_no, null: false
      t.integer :size

      t.timestamps
    end
  end
end
