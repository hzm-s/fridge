class CreateDaoPlans < ActiveRecord::Migration[6.0]
  def change
    create_table :dao_plans do |t|
      t.references :dao_product, type: :uuid, index: { unique: true }, foreign_key: true
      t.uuid :order, array: true

      t.timestamps
    end
  end
end
