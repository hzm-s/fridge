# typed: false
class CreateDaoPeople < ActiveRecord::Migration[6.0]
  def change
    create_table :dao_people, id: :uuid do |t|
      t.string :name, null: false
      t.string :email, null: false

      t.timestamps
    end

    add_index :dao_people, [:email], unique: true
  end
end
