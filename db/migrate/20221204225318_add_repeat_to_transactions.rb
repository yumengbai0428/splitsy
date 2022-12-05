class AddRepeatToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :repeat_period, :int
  end
end
