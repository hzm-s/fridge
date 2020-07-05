class CreateDaoProductBacklogItems < ActiveRecord::Migration[6.0]
  def change
    create_table :dao_product_backlog_items, id: :uuid do |t|
      t.string :content, null: false
      t.integer :size

      t.timestamps
    end
  end
end
