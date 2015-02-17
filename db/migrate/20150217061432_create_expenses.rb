class CreateExpenses < ActiveRecord::Migration
  def change
    create_table :expenses do |t|
      t.integer :user_id
      t.date :date
      t.decimal :amount, :scale => 2, :precision => 10

      t.timestamps null: false
    end
  end
end
