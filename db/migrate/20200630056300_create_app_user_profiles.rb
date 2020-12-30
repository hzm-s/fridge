# typed: false
class CreateAppUserProfiles < ActiveRecord::Migration[6.0]
  def change
    create_table :app_user_profiles do |t|
      t.references :app_user_account, type: :uuid, foreign_key: true
      t.string :initials, null: false
      t.string :fgcolor, null: false
      t.string :bgcolor, null: false

      t.timestamps
    end
  end
end
