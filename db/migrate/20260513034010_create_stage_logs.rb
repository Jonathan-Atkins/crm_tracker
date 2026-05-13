class CreateStageLogs < ActiveRecord::Migration[8.1]
  def change
    create_table :stage_logs do |t|
      t.references :customer, null: false, foreign_key: true
      t.integer :from_stage
      t.integer :to_stage

      t.timestamps
    end
  end
end
