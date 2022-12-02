class CreateRepayments < ActiveRecord::Migration
  def change
    create_table :repayments do |t|
      t.string :payer_email
      t.string :payee_email
      t.string :currency
      t.integer :amount
      t.text :description

      t.timestamps null: false
    end
  end
end
