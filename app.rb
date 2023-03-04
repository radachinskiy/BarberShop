require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def get_db
	db = SQLite3::Database.new 'barbershop.db'
	db.results_as_hash = true
	return db
end

configure do
	db = get_db
	db.execute 'CREATE TABLE IF NOT EXISTS 
		"Users" (
		"Id"	INTEGER,
		"Name"	TEXT,
		"Phone"	TEXT,
		"DateStamp"	TEXT,
		"Barber"	TEXT,
		"Color"	TEXT,
		PRIMARY KEY("Id" AUTOINCREMENT)
		);'
end

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/about' do
	erb :about
end

get '/visit' do
	erb :visit
end

get '/contacts' do
	erb :contacts	
end

get '/showusers' do
  erb :showusers
end


post '/visit' do

	@username = params[:username]
	@phone = params[:phone]
	@datetime = params[:datetime]
	@barber = params[:barber]
	@color = params[:color]

	# хеш
	hh = { 	:username => 'Введите имя',
			:phone => 'Введите телефон',
			:datetime => 'Введите дату и время' }

	@error = hh.select {|key,_| params[key] == ""}.values.join(", ")

	if @error != ''
		return erb :visit
	end

	db = get_db
	db.execute 'insert into 
		Users
		(
			name,
			phone,
			datestamp,
			barber,
			color
		)
		values (?, ?, ?, ?, ?)', [@username, @phone, @datetime, @barber, @color]

	erb "OK, username is #{@username}, #{@phone}, #{@datetime}, #{@barber}, #{@color}"

end


