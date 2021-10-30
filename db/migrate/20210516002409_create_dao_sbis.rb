# typed: ignore
class CreateDaoSbis < ActiveRecord::Migration[6.0]
  def change
    create_table :dao_sbis do |t|
      t.references :dao_sprint, type: :uuid, foreign_key: true
      t.references :dao_pbi, type: :uuid, foreign_key: true
      t.string :status, null: false
      t.integer :satisfied_criterion_numbers, array: true

      t.timestamps
    end

    add_index :dao_sbis, [:dao_sprint_id, :dao_pbi_id], unique: true
  end
end
