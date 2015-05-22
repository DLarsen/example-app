require 'csv'

# create an admin user, not particularly secure to 
Admin.create!(
	:name => 'David Larsen',
	:email => 'david.larsen@gmail.com',
	:password => 'topsecret',
	:password_confirmation => 'topsecret'
)

ActiveRecord::Base.transaction do

	csv_text = File.read('data/categories.csv')
	csv = CSV.parse(csv_text, :headers => true,:col_sep => "\t",:header_converters => :symbol)
	csv.each do |row|
	  Category.create(id:row[:category_id],name: row[:name])
	end

	csv_text = File.read('data/items.csv')
	csv = CSV.parse(csv_text, :headers => true,:col_sep => "\t",:header_converters => :symbol)
	csv.each do |row|
	  Item.create(id:row[:item_id],name: row[:name])
	end

	csv_text = File.read('data/users.csv')
	csv = CSV.parse(csv_text, :headers => true,:col_sep => "\t",:header_converters => :symbol)
	csv.each do |row|
	  User.create(id:row[:user_id],name: row[:name])
	end

end

connection = 	ActiveRecord::Base.connection()

# Page size of the database. The page size must be a power of two between 512 and 65536 inclusive
connection.execute 'PRAGMA main.page_size=4096;'

# Suggested maximum number of database disk pages that SQLite will hold in memory at once per open database file
connection.execute 'PRAGMA main.cache_size=10000;'

# Database connection locking-mode. The locking-mode is either NORMAL or EXCLUSIVE
connection.execute 'PRAGMA main.locking_mode=EXCLUSIVE;'

# Setting of the "synchronous" flag, "NORMAL" means sync less often but still more than none
connection.execute 'PRAGMA main.synchronous=OFF;'

# Journal mode for database, WAL=write-ahead log
connection.execute 'PRAGMA main.journal_mode=OFF;'

# Storage location for temporary tables, indices, views, triggers
connection.execute 'PRAGMA main.temp_store = MEMORY;'

connection.execute("BEGIN TRANSACTION")

csv_text = File.read('data/categories-items.csv')
csv = CSV.parse(csv_text, :headers => true,:col_sep => "\t",:header_converters => :symbol)
csv.each do |row|
	connection.execute("INSERT INTO categories_items (category_id,item_id) VALUES (#{row[:category_id]},#{row[:item_id]})")
end

csv_text = File.read('data/items-users.csv')
csv = CSV.parse(csv_text, :headers => true,:col_sep => "\t",:header_converters => :symbol)
csv.each do |row|
	connection.execute("INSERT INTO items_users (user_id,item_id) VALUES (#{row[:user_id]},#{row[:item_id]})")
end

connection.execute("END TRANSACTION")