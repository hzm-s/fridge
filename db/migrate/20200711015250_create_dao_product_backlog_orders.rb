# typed: ignore
class CreateDaoProductBacklogOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :dao_product_backlog_orders do |t|
      t.references :dao_product, type: :uuid, foreign_key: true, index: { name: 'idx_product_id_on_blo' }
      t.uuid :product_backlog_item_ids, array: true

      t.timestamps
    end
  end
end
