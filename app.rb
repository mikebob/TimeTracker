require 'sinatra'
require 'haml'

get '/' do
	haml :hello
end
