class CreateInformation < ActiveRecord::Migration
  def change
    create_table :information do |t|
      t.text :info
      t.integer :month
      t.integer :day
      t.integer :year
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
