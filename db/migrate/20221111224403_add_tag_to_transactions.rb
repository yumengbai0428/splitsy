class AddTagToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :tag, :string, :default => "expenditure"
  end
end
