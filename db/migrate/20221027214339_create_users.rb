class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |u|
      u.string :name
      u.string :email
      u.string :password
      u.string :default_currency, :default => "US dollar"
    end
  end
end
