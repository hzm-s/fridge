class CreateDaoSprints < ActiveRecord::Migration[6.0]
  def change
    create_table :dao_sprints, id: :uuid do |t|
      t.references :dao_product, type: :uuid, foreign_key: true
      t.integer :number, null: false

      t.timestamps
    end

    add_index :dao_sprints, [:dao_product_id, :number], unique: true
  end
end
