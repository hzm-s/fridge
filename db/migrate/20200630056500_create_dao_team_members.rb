# typed: ignore
class CreateDaoTeamMembers < ActiveRecord::Migration[6.0]
  def change
    create_table :dao_team_members do |t|
      t.references :dao_product, type: :uuid, foreign_key: true, index: false
      t.references :dao_person, type: :uuid, index: false
      t.string :role, null: false

      t.timestamps
    end

    add_index :dao_team_members, [:dao_product_id, :dao_person_id], unique: true
  end
end
