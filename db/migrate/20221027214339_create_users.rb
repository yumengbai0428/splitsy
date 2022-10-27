class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |u|
      u.string :name
      u.string :email
      u.string :password
      u.string :default_currency
    end
  end
end
