class CreateApiKeys < ActiveRecord::Migration
  def change
    create_table :api_keys do |t|
      t.integer :user_id
      t.string :token

      t.timestamps null: false
    end
  end
end
