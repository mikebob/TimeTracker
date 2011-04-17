require 'rubygems'
require 'sinatra'
require 'data_mapper'
#require 'sqlite3'
#require 'dm-core'
#require 'dm-timestamps'

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/timetracker.db")

class Entry

	include DataMapper::Resource

	property :id,			Serial
	property :user_id,		String, :required => true
	property :ticks,		String, :required => true
	property :task_id,		String, :required => true
	property :note,			Text
	property :create_date,	DateTime, :default => Time.now
	property :update_date,	DateTime, :default => Time.now

	belongs_to :task
	belongs_to :user

end

class User

	include DataMapper::Resource

	property :id,	Serial
	property :name,	String, :required => true

	has n, :entries

end

class Task

	include DataMapper::Resource

	property :id,	Serial
	property :name,	Text, :required => true

	has n, :entries

end

#create / upgrade all tables
#DataMapper.auto_upgrade!
DataMapper.auto_migrate!

get '/' do
	erb :fly
end

__END__

@@ fly
anything goes
