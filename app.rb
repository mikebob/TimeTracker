require 'rubygems'
require 'sinatra'
require 'data_mapper'
require 'oa-oauth'
#require 'sqlite3'
require 'dm-core'
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

	#belongs_to :task
	#belongs_to :user

end

class User
  include DataMapper::Resource
  property :id,         Serial
  property :uid,        String
  property :name,       String
  property :nickname,   String
  property :created_at, DateTime
  has n, :entries
end


class Task
	include DataMapper::Resource
	property :id,	Serial
	property :name,	Text, :required => true
	has n, :entries
end

#create / upgrade all tables
DataMapper.finalize
DataMapper.auto_upgrade!
#DataMapper.auto_migrate!

# You'll need to customize the following line. Replace the CONSUMER_KEY and CONSUMER_SECRET with the values you got from Twitter (https://dev.twitter.com/apps/new).
use OmniAuth::Strategies::Twitter, '0PrOlGbmCQiSpy0Gcv0LQ', '0zniWBw6kkzgEyRQV94JQBhSsanYaReC5w5LOJYgxc'

enable :sessions

helpers do
  def current_user
    @current_user ||= User.get(session[:user_id]) if session[:user_id]
  end
end

before do

	puts '[Params]'
    p params

	p params[:ticks]	


	#@usr = current_user.name

end

get '/' do
  if current_user
	@usr = current_user.name
	@whatsup = Task.all
	erb :home
  else
    #'<a href="/sign_up">create an account</a> or <a href="/sign_in">sign in with Twitter</a>'
    redirect '/auth/twitter'

	#@whatsup = Task.all


	erb :home
  end
end

get '/create' do

	#@entry = Entry.create(:user_id => 'str1', :ticks => 'str2', :task_id => 'str3', :note => 'str4')
	#@entry.save


	#@entry = Entry.new('str1', 'str2', 'str3', 'str4', Time.now, Time.now)
	#@entry.save

	#property :id,			Serial
	#property :user_id,		String 
	#property :ticks,		String
	#property :task_id,		String
	#property :note,			Text
	#property :create_date,	DateTime, :default => Time.now
	#property :update_date,	DateTime, :default => Time.now


	

	erb :create

end

post '/create' do

	@entry = Entry.new(:user_id => params[:user_id], :ticks => params[:ticks], :task_id =>
params[:task_id], :note => params[:note])
	@entry.save

	redirect('/')

end



get '/auth/:name/callback' do
  auth = request.env["omniauth.auth"]
  user = User.first_or_create({ :uid => auth["uid"]}, { :uid => auth["uid"], :nickname => auth["user_info"]["nickname"], :name => auth["user_info"]["name"], :created_at => Time.now })
  session[:user_id] = user.id
  redirect '/'
end

# any of the following routes should work to sign the user in: /sign_up, /signup, /sign_in, /signin, /log_in, /login
["/sign_in/?", "/signin/?", "/log_in/?", "/login/?", "/sign_up/?", "/signup/?"].each do |path|
  get path do
    redirect '/auth/twitter'
  end
end

# either /log_out, /logout, /sign_out, or /signout will end the session and log the user out
["/sign_out/?", "/signout/?", "/log_out/?", "/logout/?"].each do |path|
  get path do
    session[:user_id] = nil
    redirect '/'
  end
end

=begin
get '/' do

	#Entry.create(:user_id => '100', :ticks => '1234', :task_id => '1')

	erb :fly
end
=end
