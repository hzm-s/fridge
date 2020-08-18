# typed: ignore
class CreateAppUserAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :app_user_accounts, id: :uuid do |t|
      t.references :dao_person, type: :uuid, foreign_key: true, index: false
      t.string :provider, null: false
      t.string :uid, null: false
      t.string :image

      t.timestamps
    end

    add_index :app_user_accounts, [:dao_person_id], unique: true
  end
end
