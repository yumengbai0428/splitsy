class AddTimestampToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :timestamp, :datetime
  end
end
