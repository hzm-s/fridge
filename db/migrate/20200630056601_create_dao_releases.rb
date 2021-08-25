# typed: false
class CreateDaoReleases < ActiveRecord::Migration[6.0]
  def change
    create_table :dao_releases do |t|
      t.references :dao_product, type: :uuid, foreign_key: true
      t.string :title
      t.integer :number, null: false
      t.uuid :issues, array: true

      t.timestamps
    end

    add_index :dao_releases, [:dao_product_id, :number], unique: true
  end
end
