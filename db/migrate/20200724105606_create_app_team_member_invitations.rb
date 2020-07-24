class CreateAppTeamMemberInvitations < ActiveRecord::Migration[6.0]
  def change
    create_table :app_team_member_invitations, id: :uuid do |t|
      t.references :dao_product, type: :uuid, foreign_key: true
      t.datetime :created_at, null: false
    end
  end
end
