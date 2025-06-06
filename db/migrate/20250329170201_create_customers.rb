class CreateCustomers < ActiveRecord::Migration[8.0]
  def change
    create_table :customers do |t|
      t.string :name
      t.string :email
      t.string :password_digest

      t.timestamps
    end
    add_index :customers, :email, unique: true
  end
end
