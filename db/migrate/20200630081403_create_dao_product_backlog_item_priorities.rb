class CreateDaoProductBacklogItemPriorities < ActiveRecord::Migration[6.0]
  def change
    create_table :dao_product_backlog_item_priorities do |t|
      t.references :dao_product, type: :uuid, foreign_key: true, index: { name: :idx_product_id }
      t.references :dao_product_backlog_item, type: :uuid, foreign_key: true, index: { name: :idx_product_backlog_item_id }
      t.integer :position, null: false

      t.timestamps
    end
  end
end
