# typed: ignore
class CreateDaoUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :dao_users, id: :uuid do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :initials, null: false

      t.timestamps
    end

    add_index :dao_users, [:email], unique: true
  end
end
