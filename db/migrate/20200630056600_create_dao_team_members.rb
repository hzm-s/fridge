# typed: ignore
class CreateDaoTeamMembers < ActiveRecord::Migration[6.0]
  def change
    create_table :dao_team_members do |t|
      t.references :dao_team, type: :uuid, foreign_key: true
      t.references :dao_person, type: :uuid, index: false
      t.string :roles, array: true, null: false

      t.timestamps
    end
  end
end
