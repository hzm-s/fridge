# typed: ignore
class CreateDaoSbis < ActiveRecord::Migration[6.0]
  def change
    create_table :dao_sbis do |t|
      t.references :dao_pbi, type: :uuid, foreign_key: true, unique: true

      t.timestamps
    end
  end
end
