class CreateGuesses < ActiveRecord::Migration
  def change
    create_table :guesses do |t|
      t.integer :information_id
      t.integer :answer
      t.integer :kind
      t.integer :delta
      t.integer :score
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
