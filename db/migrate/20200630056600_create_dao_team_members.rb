# typed: false
class CreateDaoTeamMembers < ActiveRecord::Migration[6.0]
  def change
    create_table :dao_team_members do |t|
      t.references :dao_team, type: :uuid, foreign_key: true
      t.references :dao_person, type: :uuid, index: false
      t.string :role, null: false

      t.timestamps
    end

    add_index :dao_team_members, [:dao_team_id, :dao_person_id], unique: true
  end
end
