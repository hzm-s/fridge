# typed: false
class CreateDaoTeams < ActiveRecord::Migration[6.0]
  def change
    create_table :dao_teams, id: :uuid do |t|
      t.references :dao_product, type: :uuid, foreign_key: true, index: true
      t.string :name, null: false

      t.timestamps
    end
  end
end
