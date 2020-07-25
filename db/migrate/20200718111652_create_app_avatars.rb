class CreateAppAvatars < ActiveRecord::Migration[6.0]
  def change
    create_table :app_avatars do |t|
      t.references :dao_user, type: :uuid, foreign_key: true, index: false
      t.string :avatar_bg, null: false
      t.string :avatar_fg, null: false

      t.timestamps
    end

    add_index :app_avatars, [:dao_user_id], unique: true
  end
end
