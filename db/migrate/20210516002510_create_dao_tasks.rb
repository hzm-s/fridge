# typed: ignore
class CreateDaoTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :dao_tasks do |t|
      t.references :dao_work, foreign_key: true
      t.integer :number, null: false
      t.string :status, null: false
      t.string :content, null: false

      t.timestamps
    end

    add_index :dao_tasks, [:dao_work_id, :number], unique: true
  end
end
