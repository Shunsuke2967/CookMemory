class CreateAccounts < ActiveRecord::Migration[6.1]
  def change
    create_table :accounts do |t|
      t.string :name,       null: false
      t.index  :name,       unique: true
      t.string :hashed,     null: false
      t.string :salt,       null: false
    end
  end
end
