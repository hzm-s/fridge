class CreateDaoProductBacklogs < ActiveRecord::Migration[6.0]
  def change
    create_table :dao_product_backlogs, id: :uuid do |t|
      t.references :dao_product, type: :uuid, foreign_key: true, index: true
      t.uuid :items, array: true

      t.timestamps
    end
  end
end
