class CreateCustomers < ActiveRecord::Migration[8.1]
  def change
    create_table :customers do |t|
      t.string :name
      t.string :email
      t.string :company
      t.integer :stage, default: 0, null: false

      t.timestamps
    end
  end
end
