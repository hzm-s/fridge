class CreateDaoReleaseItems < ActiveRecord::Migration[6.0]
  def change
    create_table :dao_release_items do |t|
      t.references :dao_release, type: :uuid, foreign_key: true, index: false
      t.references :dao_pbi, type: :uuid, foreign_key: true, index: false

      t.timestamps
    end

    add_index :dao_release_items, [:dao_release_id, :dao_pbi_id], unique: true
  end
end
