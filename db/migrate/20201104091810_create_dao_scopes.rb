class CreateDaoScopes < ActiveRecord::Migration[6.0]
  def change
    create_table :dao_scopes do |t|
      t.references :dao_plan, foreign_key: true
      t.string :release_id, null: false
      t.uuid :tail, null: false

      t.timestamps
    end
  end
end
