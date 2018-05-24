class CreateCustomers < ActiveRecord::Migration[5.0]
  def change
    create_table :customers do |t|
      t.integer :user_id
      t.references :station, foreign_key: true
      t.string :customer_name
      t.integer :relationship
      t.integer :city
      t.integer :province
      t.string :address
      t.string :email
      t.string :pnumber
      t.string :avatar
      t.string :noid
      t.integer :gender
      t.string :activation_digest
      t.boolean :activated
      t.datetime :activated_at
      t.date :time_end
      t.timestamps
    end
  end
end
