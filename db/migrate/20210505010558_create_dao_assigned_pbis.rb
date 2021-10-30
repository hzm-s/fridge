# typed: ignore
class CreateDaoAssignedPbis < ActiveRecord::Migration[6.0]
  def change
    create_table :dao_assigned_pbis do |t|
      t.references :dao_sprint, type: :uuid, foreign_key: true
      t.references :dao_pbi, type: :uuid, foreign_key: true

      t.timestamps
    end
  end
end
