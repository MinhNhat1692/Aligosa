class AddDiscountToBillRecords < ActiveRecord::Migration[5.0]
  def change
    add_column :medicine_bill_records, :discount, :float
  end
end
