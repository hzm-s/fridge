# typed: ignore
class CreateDaoWorks < ActiveRecord::Migration[6.0]
  def change
    create_table :dao_works do |t|
      t.references :dao_issue, type: :uuid, foreign_key: true

      t.timestamps
    end
  end
end
