class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.string :payer_email
      t.string :payee_email
      t.text :description
      t.string :currency
      t.float :amount
      t.float :percentage
    end
  end
end
