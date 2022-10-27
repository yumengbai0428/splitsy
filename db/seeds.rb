# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

users = [{:name => 'Aladdin', :email => 'aladdin@gmail.com', :password => 'password', :default_currency => 'US dollar'},
		{:name => 'Bob', :email => 'bob@gmail', :password => 'password', :default_currency => 'US dollar'},
		{:name => 'Carla', :email => 'carla@gmail.com', :password => 'password', :default_currency => 'US dollar'},
		{:name => 'David', :email => 'david@gmail.com', :password => 'password', :default_currency => 'US dollar'},
		{:name => 'Emma', :email => 'emma@gmail.com', :password => 'password', :default_currency => 'US dollar'},
		{:name => 'Frank', :email => 'frank@gmail.com', :password => 'password', :default_currency => 'US dollar'},
		{:name => 'Greg', :email => 'greg@gmail.com', :password => 'password', :default_currency => 'US dollar'},
		{:name => 'Howard', :email => 'howard@gmail.com', :password => 'password', :default_currency => 'US dollar'},
		{:name => 'Iris', :email => 'iris@gmail.com', :password => 'password', :default_currency => 'US dollar'},
		{:name => 'Jack', :email => 'jack@gmail.com', :password => 'password', :default_currency => 'US dollar'},
  	 ]

transactions = [{:user1 => "Aladdin", :user2 => "Bob", :description => "Thai food for lunch", :currency => "US dollar", :amount => 50, :percentage => 0.25},
		{:user1 => "Aladdin", :user2 => "Bob", :description => "Concert", :currency => "US dollar", :amount => 100, :percentage => 0.5},
		{:user1 => "Aladdin", :user2 => "Carla", :description => "Bar", :currency => "US dollar", :amount => 20, :percentage => 0.75},
		{:user1 => "David", :user2 => "Aladdin", :description => "School supplies", :currency => "US dollar", :amount => 20, :percentage => 1},
		{:user1 => "Emma", :user2 => "Aladdin", :description => "Rent", :currency => "US dollar", :amount => 2000, :percentage => 0.33},
		{:user1 => "Emma", :user2 => "Jack", :description => "Rent", :currency => "US dollar", :amount => 2000, :percentage => 0.33},
		{:user1 => "Emma", :user2 => "Iris", :description => "Rent", :currency => "US dollar", :amount => 2000, :percentage => 0.33},
	]

users.each do |user|
  User.create!(user)
end

transactions.each do |transaction|
	Transactions.create!(transaction)
end