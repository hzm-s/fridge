# typed: false
class CreateDaoProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :dao_products, id: :uuid do |t|
      t.string :name, null: false
      t.string :description
      t.uuid :owner_id, null: false

      t.timestamps
    end

    add_foreign_key :dao_products, :dao_people, column: :owner_id
  end
end
