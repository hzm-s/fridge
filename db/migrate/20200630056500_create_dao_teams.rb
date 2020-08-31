class CreateDaoTeams < ActiveRecord::Migration[6.0]
  def change
    create_table :dao_teams, id: :uuid do |t|
      t.references :dao_product, type: :uuid
      t.string :name, null: false

      t.timestamps
    end
  end
end
