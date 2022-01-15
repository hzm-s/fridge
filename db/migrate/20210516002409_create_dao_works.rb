# typed: ignore
class CreateDaoWorks < ActiveRecord::Migration[6.0]
  def change
    create_table :dao_works do |t|
      t.references :dao_pbi, type: :uuid, foreign_key: true, unique: true
      t.string :status, null: false

      t.timestamps
    end
  end
end
