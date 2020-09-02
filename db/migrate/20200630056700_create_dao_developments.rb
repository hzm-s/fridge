class CreateDaoDevelopments < ActiveRecord::Migration[6.0]
  def change
    create_table :dao_developments do |t|
      t.references :dao_product, type: :uuid, foreign_key: true
      t.references :dao_team, type: :uuid, foreign_key: true

      t.timestamps
    end
  end
end
