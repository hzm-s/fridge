# typed: ignore
class CreateAppOauthAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :app_oauth_accounts do |t|
      t.references :dao_user, type: :uuid, foreign_key: true, index: false
      t.string :provider, null: false
      t.string :uid, null: false

      t.timestamps
    end

    add_index :app_oauth_accounts, [:dao_user_id], unique: true
  end
end
