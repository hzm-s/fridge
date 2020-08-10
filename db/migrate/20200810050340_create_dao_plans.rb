class CreateDaoPlans < ActiveRecord::Migration[6.0]
  def change
    create_table :dao_plans do |t|
      t.references :dao_product, type: :uuid, foreign_key: true, index: true
      t.json :releases

      t.timestamps
    end
  end
end
